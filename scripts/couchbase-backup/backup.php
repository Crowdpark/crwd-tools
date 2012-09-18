<?php

function run()
{
    $options = getopt('h:b:d:s');

    $host           = isset($options['h']) ? $options['h'] : false;
    $bucket         = isset($options['b']) ? $options['b'] : false;
    $dest           = isset($options['d']) ? $options['d'] : $bucket . '_' . date('Ymd-s', time());
    $s3Backup       = isset($options['s']) ? true : false;
    $s3BackupBucket = 's3://crowdpark-berlin-deploy/backups/';
    $pipes          = array();
    $cwd            = '/tmp';
    $descriptorspec = array(
        0 => array("pipe", "r"),
        1 => array("pipe", "w"),
        2 => array("file", "/dev/null", "a"),
    );

    if ($host == false || $bucket == false || $dest == false) {
        die('-h HOST -b BUCKETNAME -d DESTINATION DIR [-s S3 BACKUP]');
    }

    $skip        = 0;
    $limit       = 1000;
    $baseUrl     = 'http://' . $host . ':8092/' . $bucket . '/_all_docs?skip=0&limit=1';
    $fetchUrl    = 'http://' . $host . ':8092/' . $bucket . '/_all_docs?skip=%d&limit=%d&include_docs=true';
    $destDir     = $cwd . '/' . $dest;
    $destArchive = $dest . '.tar.gz';

    chdir($cwd);

    printf("baseUrl = '%s'\n", $baseUrl);

    $bucketStatus = json_decode(file_get_contents($baseUrl), true);

    $rows = $bucketStatus['total_rows'];
    $runs = ceil($rows / $limit) + 1;

    printf("%s contains %d elements = %d single backup files in '%s'\n", $bucket, $rows, $runs, $destDir);

    mkdir($destDir, 0777);

    for ($i = 0; $i < $runs; $i++) {
        $filename = $destDir . '/' . $i . '.json';

        if (is_file($filename)) {
            die("FATAL: '$filename' already in use!'");
        }

        $fh  = fopen($filename, 'w');
        $url = sprintf($fetchUrl, $i * $limit, $limit);
        printf("url = '%s'\n", $url);
        fwrite($fh, file_get_contents($url));
        fclose($fh);
    }

    echo("backup done... now creating an archive of the files...\n");

    $tarProc = proc_open(
        'tar czvvf ' . $destArchive . ' ' . $dest,
        $descriptorspec, $pipes, $cwd, null
    );

    if (is_resource($tarProc)) {
        if (proc_close($tarProc) !== 0) {
            die('tar encountered an error!');
        }
    } else {
        die('tar archiving failed!');
    }

    shell_exec('rm -rf ' . $destDir);

    printf("the complete backup (archive) can be found here: %s\n", $destArchive);

    if ($s3Backup === true) {
        echo ("backup will be stored to S3 bucket.");

        $s3Proc = proc_open(
            's3cmd put ' . $destArchive . ' ' . $s3BackupBucket,
            $descriptorspec, $pipes, $cwd, null
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