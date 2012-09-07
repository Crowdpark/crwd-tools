<?php
echo "Sync Starting" . PHP_EOL;

$targetHost     = "couchbase-server";
$targetPort     = "11211";
$remoteApiUrl   = "http://ec2-54-247-28-110.eu-west-1.compute.amazonaws.com:8092";
$remoteBucket   = "casino";
$remoteViewName = "all";
$remoteDesign   = "portal";

$allData    = json_decode(file_get_contents("http://ec2-54-247-28-110.eu-west-1.compute.amazonaws.com:8092/casino/_all_docs?include_docs=true"), TRUE);
$rawData    = $allData['rows'];
$totalItems = count($rawData);

echo "Total Sync items: $totalItems" . PHP_EOL;

try {
    $insertAdapter = new \Memcached("default");
    $insertAdapter->addServer($targetHost, $targetPort);
    $result        = $insertAdapter->set("foo", array("name" => "bar_" . mt_rand(0, 1394898304))); // Testing if couchbase responding or not! Expiredtime is 1 sec.
} catch (\Exception $error) {
    var_dump($error);
}

$createdItems = 0;
$errorItems   = 0;
foreach ($rawData as $key => $value) {
    $data = $value['doc'];
    $meta = $data['meta'];
    $json = $data['json'];

    $result = $insertAdapter->set($meta['id'], json_encode($json), 0);

    if ($result == 0) {
        $createdItems++;
    } else {
        $errorItems++;
    }
}

echo "Successfull Sync items: $createdItems" . PHP_EOL;
echo "Error Sync items: $errorItems" . PHP_EOL;
echo "Sync done" . PHP_EOL;

