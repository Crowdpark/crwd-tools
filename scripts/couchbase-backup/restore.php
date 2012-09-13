<?php
include __DIR__ . "/../../library/Processus/bin/initProcessus.php";

function run()
{
    $options = getopt('h:p:d:');

    $targetHost = isset($options['h']) ? $options['h'] : false;
    $targetPort = isset($options['p']) ? $options['p'] : false;
    $backupDir  = isset($options['d']) ? $options['d'] : false;

    if ($targetHost == false || $targetPort == false || $backupDir == false) {
        die('-h HOST -p PORT (see bucket details) -d BACKUP DIR');
    }

    if (!is_dir($backupDir)) {
        die("FATAL: can't find '$backupDir''");
    }

    $insertAdapter = new \Memcached("default");
    $insertAdapter->addServer($targetHost, $targetPort);

    foreach (findJsonFiles($backupDir) as $jsonFile) {
        $rawData = json_decode(file_get_contents($backupDir . '/' . $jsonFile), true);

        foreach ($rawData['rows'] as $key => $value) {
            $data = $value['doc'];
            $json = $data['json'];

            $result = $insertAdapter->set($data['meta']['id'], json_encode($json), 0);

            print_r($data['meta']['id']);
            echo("\n");
        }

        unset($rawData);
    }
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