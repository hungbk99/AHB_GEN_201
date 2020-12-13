transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {d:/intelfpga_lite/18.1/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {d:/intelfpga_lite/18.1/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {d:/intelfpga_lite/18.1/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {d:/intelfpga_lite/18.1/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {d:/intelfpga_lite/18.1/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cyclonev_ver
vmap cyclonev_ver ./verilog_libs/cyclonev_ver
vlog -vlog01compat -work cyclonev_ver {d:/intelfpga_lite/18.1/quartus/eda/sim_lib/mentor/cyclonev_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {d:/intelfpga_lite/18.1/quartus/eda/sim_lib/mentor/cyclonev_hmi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {d:/intelfpga_lite/18.1/quartus/eda/sim_lib/cyclonev_atoms.v}

vlib verilog_libs/cyclonev_hssi_ver
vmap cyclonev_hssi_ver ./verilog_libs/cyclonev_hssi_ver
vlog -vlog01compat -work cyclonev_hssi_ver {d:/intelfpga_lite/18.1/quartus/eda/sim_lib/mentor/cyclonev_hssi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_hssi_ver {d:/intelfpga_lite/18.1/quartus/eda/sim_lib/cyclonev_hssi_atoms.v}

vlib verilog_libs/cyclonev_pcie_hip_ver
vmap cyclonev_pcie_hip_ver ./verilog_libs/cyclonev_pcie_hip_ver
vlog -vlog01compat -work cyclonev_pcie_hip_ver {d:/intelfpga_lite/18.1/quartus/eda/sim_lib/mentor/cyclonev_pcie_hip_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_pcie_hip_ver {d:/intelfpga_lite/18.1/quartus/eda/sim_lib/cyclonev_pcie_hip_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Sample {D:/Project/AMBA_BUS/AHB_GEN_201/Sample/AHB_package.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Sample {D:/Project/AMBA_BUS/AHB_GEN_201/Sample/AHB_arbiter_package.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux/AHB_si_mux_master_3.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux/AHB_si_mux_master_2.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux/AHB_si_mux_master_1.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux/AHB_si_mux_kemee.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux/AHB_mi_mux_slave_7.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux/AHB_mi_mux_slave_6.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux/AHB_mi_mux_slave_5.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux/AHB_mi_mux_slave_4.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux/AHB_mi_mux_slave_3.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux/AHB_mi_mux_slave_2.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/mux/AHB_mi_mux_slave_1.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/decoder {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/decoder/AHB_decoder_master_3.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/decoder {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/decoder/AHB_decoder_master_2.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/decoder {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/decoder/AHB_decoder_master_1.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/decoder {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/decoder/AHB_decoder_kemee.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/arbiter {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/arbiter/AHB_arbiter_slave_7.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/arbiter {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/arbiter/AHB_arbiter_slave_6.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/arbiter {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/arbiter/AHB_arbiter_slave_5.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/arbiter {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/arbiter/AHB_arbiter_slave_4.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/arbiter {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/arbiter/AHB_arbiter_slave_3.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/arbiter {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/arbiter/AHB_arbiter_slave_2.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/arbiter {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/arbiter/AHB_arbiter_slave_1.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/AHB_bus.sv}
vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result {D:/Project/AMBA_BUS/AHB_GEN_201/Gen_Result/TOP.sv}

vlog -sv -work work +incdir+D:/Project/AMBA_BUS/AHB_GEN_201/test {D:/Project/AMBA_BUS/AHB_GEN_201/test/test.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  AHB_tb

add wave *
view structure
view signals
run -all
