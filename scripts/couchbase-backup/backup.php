<?php

function run()
{
    $options = getopt('h:b:d:');

    $host   = isset($options['h']) ? $options['h'] : false;
    $bucket = isset($options['b']) ? $options['b'] : false;
    $dest   = isset($options['d']) ? $options['d'] : $bucket . '_' . date('Ymd-s', time());

    if ($host == false || $bucket == false || $dest == false) {
        die('-h HOST -b BUCKETNAME -d DESTINATION DIR');
    }

    $skip     = 0;
    $limit    = 1000;
    $baseUrl  = 'http://' . $host . ':8092/' . $bucket . '/_all_docs?skip=0&limit=1';
    $fetchUrl = 'http://' . $host . ':8092/' . $bucket . '/_all_docs?skip=%d&limit=%d&include_docs=true';
    $destDir  = '/tmp/' . $dest;

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

        $fh = fopen($filename, 'w');
        $url = sprintf($fetchUrl, $i*$limit, $limit);
        printf("url = '%s'\n", $url);
        fwrite($fh, file_get_contents($url));
        fclose($fh);
    }
}

run();

//EOF