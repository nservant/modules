#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { COOLTOOLS_EIGSCIS } from '../../../../modules/cooltools/eigscis/main.nf'

workflow test_cooltools_eigscis {
    
    input = [
        [ id:'test', single_end:false ], // meta map
          file('https://github.com/open2c/cooltools/blob/master/tests/data/sin_eigs_mat.cool')
    ]

    COOLTOOLS_EIGSCIS ( input )
}
