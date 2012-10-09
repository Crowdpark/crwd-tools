<?php

function run()
{
    $options = getopt('h:b:d:s:f');

    $host           = isset($options['h']) ? $options['h'] : FALSE;
    $bucket         = isset($options['b']) ? $options['b'] : FALSE;
    $dest           = isset($options['d']) ? $options['d'] : $bucket . '_' . date('Ymd-s', time());
    $s3Backup       = isset($options['s']) ? TRUE : FALSE;

    $s3BackupBucket = 's3://crowdpark-berlin-deploy/backups/';
    $pipes          = array();
    $descriptorspec = array(
        0 => array("pipe", "r"),
        1 => array("pipe", "w"),
        2 => array("file", "/dev/null", "a"),
    );

    if ($host == FALSE || $bucket == FALSE || $dest == FALSE) {
        die('-h HOST -b BUCKETNAME -d DESTINATION DIR [-s S3 BACKUP]' . PHP_EOL);
    }

    $skip        = 0;
    $limit       = 1000;
    $baseUrl     = 'http://' . $host . ':8092/' . $bucket . '/_design/backup/_view/all?skip=0&limit=1';
    $fetchUrl    = 'http://' . $host . ':8092/' . $bucket . '/_design/backup/_view/all?skip=%d&limit=%d&include_docs=true';
    $destDir     = $dest;

    printf("baseUrl = '%s'\n", $baseUrl);

    /** fetching totalRows stats from the couchbase */
    $bucketStatus = json_decode(file_get_contents($baseUrl), TRUE);

    $rows = $bucketStatus['total_rows'];
    $runs = ceil($rows / $limit) + 1;

    echo "Destination: " . $destDir . PHP_EOL;

    /** creating recursive folders if needed */
    if (is_dir($destDir) == FALSE) {
        mkdir($destDir, 0777, TRUE);
    }

    $filename = 'backup_' . time() . '.json';
    $rawFile = $destDir . $filename;
    $destArchive = $dest . $filename . '.tar.gz';

    echo "Complete Path: " . $rawFile . PHP_EOL;
    echo "Archive Path: " . $destArchive . PHP_EOL;

    for ($i = 0; $i < $runs; $i++) {
        //$filename = $destDir . '/' . $i . '.json';

//        if (is_file($filename)) {
//            die("FATAL: '$filename' already in use!'");
//        }

        //$fh  = fopen($filename, 'w');
        $url = sprintf($fetchUrl, $i * $limit, $limit);
        printf("url = '%s'\n", $url);

        if (is_file($rawFile)) {
            file_put_contents($rawFile, file_get_contents($url), FILE_APPEND);
        } else {
            file_put_contents($rawFile, file_get_contents($url));
        }

    }

    echo("backup done... now creating an archive of the files...\n");

    $tarProc = proc_open(
        'tar czvvf ' . $destArchive . ' ' . $rawFile,
        $descriptorspec, $pipes, $filename, NULL
    );

    if (is_resource($tarProc)) {
        if (proc_close($tarProc) !== 0) {
            die('tar encountered an error!');
        }
    } else {
        die('tar archiving failed!');
    }

    printf("the complete backup (archive) can be found here: %s\n", $destArchive);

    if ($s3Backup === TRUE) {
        echo ("backup will be stored to S3 bucket.");

        $s3Proc = proc_open(
            's3cmd put ' . $destArchive . ' ' . $s3BackupBucket,
            $descriptorspec, $pipes, $cwd, NULL
        );

        if (is_resource($s3Proc)) {
            if (proc_close($s3Proc) !== 0) {
                die('s3cmd encountered an error!');
            }
        } else {
            die('s3cmd transfer failed!');
        }

        unlink($destArchive);
        echo("listing of all files in S3 backup bucket:\n");
        system('s3cmd ls ' . $s3BackupBucket);
        echo("\n\ndone.\n");
    }
}

run();

//EOF