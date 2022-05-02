# Grafatheus (Grafana & Prometheus)
This project was made to make a clean and easy monitoring installation using Prometheus, Node Exporter and Grafana. It requires a few packages that many server are delivered with :
- ``ufw`` : manages the firewall,
- ``curl`` : allows to make web requests,
- ``gnupg2`` : deals with GNU GPG keys for packages,
- ``software-properties-common`` : deals with apt external packages.

There are some resources you amy want to read before starting to install these components :
- [Prometheus](https://prometheus.io/),
- [Node Exporter](https://prometheus.io/docs/guides/node-exporter/),
- [Grafana](https://grafana.com/).

# Specifications
This project works fine for Linux ADM64 systems and was only tested by me on a Debian 11 machine. You may have some trouble. If it's the case, you may open an issue.
In addition, those ports are meant to be opened :
- ``9090`` : Prometheus,
- ``9100`` : Node Exporter,
- ``3000`` : Grafana.

# Install dependencies (if not done yet)
To easily install dependencies, there is a bash script called ``requirements.bash`` that will to the job for you. The only thing you have to do is to run the script in sudo mode.

# Install monitors
Once you have the requirements installed on your machine, you can execute the ``install.bash`` script.

### Prometheus
The first thing that's going to be installed is prometheus. It will try to open the port 9090. If an error occurs and the script isn't able to do so, you may not be able to access to the metrics if not in a local server.

### Node Exporter
The second thing is called Node Exporter. It's a component required to scrap the metrics. It also needs to open a port, the 9100 one. Same thing as above, if it can't, you may not be able to access to the metrics.

### Grafana
The last but not least is Grafana. As same as above, it must be able to open the port 3000. If it can't, you will not be able to reach the monitor.

# Copy-To-Install

```bash
# Clone the repository
git clone https://github.com/Ximaz/grafatheus
cd grafatheus

# Changes permissions for non-admin users
chmod -R og=r *.bash scripts/*.bash README.md

# Start the setup process
sudo ./requirements.bash
sudo ./install.bash
```
