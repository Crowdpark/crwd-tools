<?php
include __DIR__ . "/../../library/Processus/bin/initProcessus.php";

function run()
{
    $options = getopt('h:p:d:s:');

    $targetHost = isset($options['h']) ? $options['h'] : false;
    $targetPort = isset($options['p']) ? $options['p'] : false;
    $backupDir  = isset($options['d']) ? $options['d'] : false;
    $s3Archive  = isset($options['s']) ? $options['s'] : false;
    $cwd        = '/tmp';

    if ($targetHost == false || $targetPort == false || ($backupDir == false && $s3Archive == false)) {
        die('-h HOST -p PORT (see bucket details) [-d BACKUP DIR or -s S3 URL]');
    }

    chdir($cwd);

    if ($s3Archive !== false) {
        $tarArchivePath = $cwd . '/' . basename($s3Archive);
        unlink($tarArchivePath);
        system('s3cmd get ' . $s3Archive . ' ' . $cwd);
        system('tar xzvvf ' . $tarArchivePath);
        preg_match('/(.*)?\.t.*$/', basename($s3Archive), $info);
        $backupDir = $cwd . '/' . $info[1];
    }

    if (!is_dir($backupDir)) {
        die("FATAL: can't find '$backupDir'");
    }

    $insertAdapter = new \Memcached("default");
    $insertAdapter->addServer($targetHost, $targetPort);

    foreach (findJsonFiles($backupDir) as $jsonFile) {
        printf("restoring '%s'...\n", $jsonFile);

        $rawData = json_decode(file_get_contents($backupDir . '/' . $jsonFile), true);

        foreach ($rawData['rows'] as $key => $value) {
            $data = $value['doc'];
            $json = $data['json'];

            $result = $insertAdapter->set($data['meta']['id'], json_encode($json), 0);

            if ($result !== true) {
                printf("ID '%s' could NOT be restored!\n", $data['meta']['id']);
            }
        }

        unset($rawData);
    }

    echo ("\n\ndone.\nDo not forget to remove the dir where the restore was taken from: $backupDir\n");
}

function findJsonFiles($directory = '')
{
    $jsonFiles = array();

    if ($handle = opendir($directory)) {
        while (false !== ($entry = readdir($handle))) {
            if (preg_match('/.*?\.json$/', $entry)) {
                $jsonFiles[] = $entry;
            }
        }
        closedir($handle);
    }

    return $jsonFiles;
}

run();

//EOF