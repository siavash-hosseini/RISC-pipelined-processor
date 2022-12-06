# RISC-pipelined-processor-
Implementation of RISC-like pipelined processor 


In this project, a pipelined processor was implemented and simulated using the Verilog in ModelSim. Alongside the main modules and pipeline registers, data Forwarding and Hazard Detection Unit are added to the design. At first, the main part of the processor with stall capability has been implemented in case of data dependence, and in the next steps, modules such as forwarding unit, Hazard Detection Unit, etc. have been added to the architecture. The implemented processor is a 5-stage pipeline processor. Between each step, there are a series of registers in which the values of the next command that are to be entered in the next clock are stored. 
