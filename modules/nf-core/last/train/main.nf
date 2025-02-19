process LAST_TRAIN {
    tag "$meta.id"
    label 'process_high'

    conda "bioconda::last=1418"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/last:1418--h5b5514e_0' :
        'biocontainers/last:1418--h5b5514e_0' }"

    input:
    tuple val(meta), path(fastx)
    path  index

    output:
    tuple val(meta), path("*.par"), emit: param_file
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    INDEX_NAME=\$(basename \$(ls $index/*.des) .des)

    last-train \\
        $args \\
        -P $task.cpus \\
        ${index}/\$INDEX_NAME \\
        $fastx \\
        > ${prefix}.\$INDEX_NAME.par

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        last: \$(lastdb --version | sed 's/lastdb //')
    END_VERSIONS
    """
}
