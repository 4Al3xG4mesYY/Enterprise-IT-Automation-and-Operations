# DNS Validation Tool
Develop a Python-based infrastructure validation tool capable of:
* Identifying reachable hosts
* Performing reverse DNS validation (IP → Hostname)
* Performing forward DNS validation (Hostname → IP)
* Identifying DNS inconsistencies
* Exporting findings to CSV
* Producing actionable infrastructure reports

_The tool was developed during an enterprise subnet inventory and DNS validation initiative._

### Features
* ICMP Reachability Validation
* Reverse DNS Validation
* Forward DNS Validation
* Forward IP Verification
* CSV Reporting
* Classification-Based Results

### Lessons Learned
I learned to check false positives while communicating with my senior about this task with making a proper report so both them and the corporate side would.
Initially the code only checked reverse DNS and not the forward dns, this caused confusion when looking at a device that had a reverse dns in one scan.
Then another scan it only had the forward dns when scanning it's IP address and using nslookup. Afterwards, I was able to produce a deliverable.
I was also able to develop a methodology that my senior was able to understand and added coloring for more clarity. 

