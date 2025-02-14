default: obj_dir/Vprocessor_top

obj_dir/Vprocessor_top: obj_dir/Vprocessor_top.mk
	make -C obj_dir -f Vprocessor_top.mk
	@echo "./obj_dir/Vprocessor_top to run test bench"

obj_dir/Vprocessor_top.mk: loopyV_constants.svh loopyV_data_types.sv hazard_control.sv decoder.sv pcReg.sv controller.sv registerfile.sv alu.sv dm_interface.sv pipeIFDE.sv pipeEXMEM.sv pipeDEEX.sv pipeMEMWB.sv processor_top.sv processor_top_sim.cpp
	verilator --top-module processor_top  --trace  -cc loopyV_constants.svh loopyV_data_types.sv hazard_control.sv decoder.sv pcReg.sv controller.sv registerfile.sv alu.sv dm_interface.sv pipeIFDE.sv pipeEXMEM.sv pipeDEEX.sv   pipeMEMWB.sv processor_top.sv --exe processor_top_sim.cpp
clean:
	rm -rf obj_dir