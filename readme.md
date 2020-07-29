# Probe documentation

This probe is a software that listens on a network interface to capture traffic, based on filters that can be configured. Once the traffic is captured it is able to extract KPIs from it based on calculating flow metrics. Finally, the probe sends the calculated KPIs to an Influxdb database.

The probe is able to handle TCP, ICMP and GTP-U traffic: 
 - From TCP traffic it can calculate:
    *  Throughput, uplink and downlik, in bytes per second.
    *  Smooth round-trip time (SRTT). 
 - From ICMP traffic it can calculate: 
    * Throughput, uplink and downlik, in bytes per second. 
    * Round trip time (RTT).
 - From GTP-U traffic:
    * It extracts the ends of the GTP tunnel and treats the encapsulated packet.    


## APIs
By default the probe has an API that listens on port 5100. This API exposes the following endpoints: 

* Endpoints for configuring and managing the probe's sniffer:

| METHOD 	| URL 	| BODY 	| DESCRIPTION 	|  	|
|:------:	|:-------------:	|:------------------------:	|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:	|---	|
| POST 	| /probe/start 	| {"filter":"tcp or icmp"} 	| The sniffer of the probe is started with the filter indicated in the body of the request (JSON). The filter has to comply with the BPF syntax. Examples: tcp port 80, tcp port 80 or icmp... 	|  	|
| GET 	| /probe/stop 	| - 	| It stops the sniffer if it is active. 	|  	|
| GET 	| /probe/status 	| - 	| Check the sniffer's status, if active, it will indicate the active filter. 	|  	|

* Endpoints for checking the information that the probe has:

| METHOD 	| URL 	| DESCRIPTION 	|
|:------:	|:----:	|:---------------------------------------------------------------------------------------------:	|
| GET 	| /kpi 	| The information of KPIs that are currently in the probe's internal storage will be displayed. 	|
| GET 	| /owd 	| The information of OWD that is currently in the probe's internal storage will be displayed. 	|
|  	|  	|  	|


## Configuration and execution

In this secction it will be explained how to configure and install the probe.

To make configuration and execution simple, two scripts will be provided. The first one called setupProbe.sh which installs dependencies and gives the binary called probe the permissions it needs to capture traffic. The second one called launchProbe.sh will run the probe using the configuration file probe_config.yml and generate a file called output.txt in which the probe's log will be written.

### probe_config.yml
In this section you can see what the configuration file looks like and an example of it.

      probeID:  <Probe identifier>
      databaseIP: <InfluxDB IP address>
      dbUser: <Database user name>
      dbPassword: <Database user name password>
      dbWriteInterval: <Time in seconds indicating how often the metrics will be written from the probe to the database. By default, 10 seconds>
      interface: <Name of the interface where the probe are going to sniff>
      userPool: <List of subnets where users are>

An example of configuration is shown below  

      probeID: APP
      databaseIP: 10.3.3.30
      dbUser: admin
      dbPassword: admin
      dbWriteInterval: 10
      interface: enx0
      userPool:
         5G:
          - 10.3.7.0/24
          - 10.3.7.240/28
         4G:
          - 10.3.0.40/29
          - 10.3.0.32/29
          - 10.3.0.120/29


### Example of execution:
      
      $ ls
      launchProbe.sh  probe  probe_config.yaml  setupProbe.sh

      $ ./setupProbe.sh

      $ ./launchProbe.sh

When the launchProbe.sh script is executed the probe will be in background and listening on port 5100 where requests can be sent to configure the sniffer and view the data stored in the probe. 

   * Start sniffing:
      
      $ curl -X POST -d '{"filter": "tcp or icmp"}' IP:5100/probe/start

   * Stop sniffing:
      $ curl IP:5100/probe/stop
