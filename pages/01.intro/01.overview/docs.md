---
title: Overview
taxonomy:
    category: docs
---


### WHAT

The WARP Core is a HDL processor based off the open source RISCV architecture. Several different tools will be used to build and test this soft-core processor.  First, EDA Playground will be used with system verilog to setup a test bench with assertions and full coverage to exercise the methods I have learned in my verification class.  Next, UVM will be used within EDA Playgoudn to create a test bench and understand it's potential and wide use in industry.  Finally, Cocotb (Pyhton based verification tool) will be used to design test benches to test both languages.  Icarus Veilog will be used to simulate the Verilog design. GHDL will be used to simulate the VHDL design. The final step is important to understand the the difference in tools and languages as well as the potential of open-source software.

### Why

The main purpose for this project is for me to apply what I learn in my various classes to a single project. Mainly, understanding, implementing, and optimizing computer architecture, and using constrained random test benches to verify the design.  I will also explore other methods such as test-driven design to understand the benefits it can bring to the work I do professionally.  I want to provide the steps so any student or hobbyist can do the project themselves with free open source software and easy to obtain hardware (Digilent PYNQ or ARTY).  The end goal for this project is to add hardware and software mitigation to produce a fault-tolerant soft-core processor to be used in FPGA-based satellite processing. 

### Who

This project is by Andrew E Wilson, a graduate student at Brigham Young University and a Pathways Intern at NASA GSFC.

This project is for students, hobbyist, potential employers, and the curious individual.
