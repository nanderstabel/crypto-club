# crypto-club

Clone this repository in your home folder:
```
git clone https://github.com/nanderstabel/crypto-club.git
```

Move server-setup.sh script to home folder and run it:
```
mv crypto-club/server-setup.sh .
source ./server-setup.sh
```

After compiling your WASP-node automatically starts running. Let it run and continue working in a new terminal. You can check if the node is indeed running by opening the dashboard by visiting \<IP address\>:7000 in your browser.
You can find your IP address using this command: `hostname -I`.

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
