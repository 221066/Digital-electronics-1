#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2020.2 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Sun May 02 00:18:15 CEST 2021
# SW Build 3064766 on Wed Nov 18 09:12:47 MST 2020
#
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# elaborate design
echo "xelab -wto 862cc2acd25245788d891bb96bc282ab --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot tb_displayer_behav xil_defaultlib.tb_displayer -log elaborate.log"
xelab -wto 862cc2acd25245788d891bb96bc282ab --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot tb_displayer_behav xil_defaultlib.tb_displayer -log elaborate.log

