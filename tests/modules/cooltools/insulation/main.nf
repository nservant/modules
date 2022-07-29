#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { COOLTOOLS_INSULATION } from '../../../../modules/cooltools/insulation/main.nf'

workflow test_cooltools_insulation {
    
    input = [
        [ id:'test', single_end:false ], // meta map
        file('https://github.com/open2c/cooltools/blob/master/tests/data/CN.mm9.1000kb.cool')]

    COOLTOOLS_INSULATION ( input )
}
