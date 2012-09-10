<?php
return array(
    'processus'      => array(
        'beanstalkd'      => array(
            'servers' => array(
                "1" => array(
                    "host" => "127.0.0.1",
                    "port" => ""
                ),
                "2" => array(
                    "host" => "127.0.0.1",
                    "port" => ""
                ),
                "3" => array(
                    "host" => "127.0.0.1",
                    "port" => ""
                )
            ),
            'workers' => array()
        ),
        'couchbaseConfig' => array(
            'couchbaseSalt'    => "Crowdpark4Ever!",
            'couchbaseTime'    => array(
                'default'   => array(),
                'fbusers'   => array(),
                'deeplink'  => array(),
                'userStake' => array(),
                'tmp'       => array(),
            ),
            'couchbasePorts'   => array(
                'default'        => array(
                    "host" => "127.0.0.1",
                    "port" => "11211"
                ),
            ),
            'couchbaseServers' => array(
                "0" => array(
                    "id"   => "default",
                    "host" => "127.0.0.1"
                ),
                "1" => array(
                    "id"   => "default",
                    "host" => "127.0.0.1"
                ),
                "2" => array(
                    "id"   => "default",
                    "host" => "127.0.0.1"
                ),
                "3" => array(
                    "id"   => "default",
                    "host" => "127.0.0.1"
                )
            )
        ),
    ),

    'locale'         => array(
        'default' => array(
            'lc_all'   => 'C',
            'timezone' => 'Europe/Berlin'
        )
    ),

    // ++++++++++++++ fb: osapi ++++++++++++++++++++++++++++++++++++++

    'Facebook'       => array(
        "appId"  => "", //"APIKEY",
        "secret" => "" //"APISECRET",
    ),

    // ++++++++++++++ fb: osapi ++++++++++++++++++++++++++++++++++++++

    'Profiler'       => array(
        "ips" => array(""),
    ),

    'Logging'        => array(

    ),

);