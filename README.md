# crypto-club

## Get a VPS instance

### LeafCloud
Create an account on [LeafCloud](https://www.leaf.cloud).

Under > Compute > Instances: launch a new instance:
* Details: Give your instance a name and state the amount of instances you want to launch in 'Count'
* Source: 'Select Boot Source' should be 'Image' and keep 'Volume Size' at 1. Move 'Ubuntu-20.04' from 'Available' to 'Allocated'
* Flavor: Move 'ec1.xsmall' to 'Available'
* Network: An external network should be listed under 'Allocated'
* Key Pair: Add your public ssh key.
* Click on 'Launch Instance'

Under > Network > Security Groups: Click on 'Manage Rules' for the default security group:
* Click 'Add Rule'
* Rule: Select 'All TCP'
* Direction: 'Ingress'
* Remote: 'CIDR'
* CIDR: '0.0.0.0/0'
* Click 'Add'

Go back to Compute > Instances and check your the IP Address of your instance. Use it to login using: `ssh ubuntu@<IP Address>`

### DigitalOcean
Create an account on [DigitalOcean](https://www.digitalocean.com/).
Select your project and create a Droplet:
* Choose 'Ubuntu 20.04' as your image
* Select the 'Basic' shared CPU plan
* Select 'Regular Intel' option with 1 GB / 1 CPU, 25 GB SSD Disk and 1000 GB transfer
* Select a datacenter region
* Select 'Monitoring' under additional options
* Select 'SSH keys' under Authentication and add your SSH key.
* Select the amount of Droplets you want and name them
* Click 'Create Droplet'

Wait for your Droplet to initialize and use the IP Address to login using: `ssh root@IP Address>`

## WASP node setup

Clone this repository in the home folder of your instance:
```
git clone https://github.com/nanderstabel/crypto-club.git
```

Move server-setup.sh script to home folder and run it:
```
mv crypto-club/server-setup.sh .
source ./server-setup.sh
```

After compiling your WASP-node automatically starts running. Let it run and continue working in a new terminal. You can check if the node is indeed running by opening the dashboard by visiting \<IP address\>:7000 in your browser.
You can find your IP address using this command: `hostname -I`. Make sure it is a public IP if you want to connect with nodes outside your network.

It will ask for a username and password; both of them are `wasp` by default.

If you want to start a committee of multiple nodes you will need the `PubKey` and `NetID` from all the nodes you want to *peer* with. Your peers can acquire this information using the following command in their wasp folder:
```
./wasp-cli peering info
```

To help you add your peers to your committee move the `node_peering.sh` script to your wasp folder:
```
mv ../crypto-club/node_peering.sh .
```

For each node you want to add to your committee run the command below. Beware that for each new node you add you need to increment the first argument (starting at 1):
```
./node_peering.sh 1 <PubKey> <NetID>
```
Don't forget to add your own PubKey and NetID to your peer nodes as well.

Check if all nodes are added succesfully:
```
./wasp-cli peering list-trusted
```

You might need to restart all nodes in the committee before continuing:
```
./wasp --logger.level="warn"
```

For deploying a chain and add smart contracts follow [this](https://wiki.iota.org/wasp/guide/chains_and_nodes/setting-up-a-chain#deploy-the-iscp-chain) guide.

When you're done with your node for the day, I recommend to do the following:
Check in your config.json file if under logger.outputPaths there is an array with `stdout` and `wasp.log` . Delete wasp.log, the array should look like this: `["stdout"]` .
This will prevent you from running out of disk space.
Also make sure to run your wasp node like this:
```
nohup ./wasp >/dev/null 2>&1 &
```
Nohup will allow you to keep wasp running when not logged into your instance. The second part of the command makes sure no log-file is created
