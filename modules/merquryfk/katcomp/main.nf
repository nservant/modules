process MERQURYFK_KATCOMP {
    tag "$meta.id"
    label 'process_medium'

    if (params.enable_conda) {
        error "Conda environments cannot be used when using the FastK tool. Please use docker or singularity containers."
    }
    // WARN: Version information not provided by tool on CLI. Please update version string below when bumping container versions.
    container 'ghcr.io/nbisweden/fastk_genescopefk_merquryfk:1.0'

    input:
    tuple val(meta), path(fastk1_hist), path(fastk1_ktab), path(fastk2_hist), path(fastk2_ktab)

    output:
    tuple val(meta), path("*.fi.png"), emit: filled_png , optional: true
    tuple val(meta), path("*.ln.png"), emit: line_png   , optional: true
    tuple val(meta), path("*.st.png"), emit: stacked_png, optional: true
    tuple val(meta), path("*.fi.pdf"), emit: filled_pdf , optional: true
    tuple val(meta), path("*.ln.pdf"), emit: line_pdf   , optional: true
    tuple val(meta), path("*.st.pdf"), emit: stacked_pdf, optional: true
    path "versions.yml"              , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def FASTK_VERSION = 'f18a4e6d2207539f7b84461daebc54530a9559b0' // WARN: Version information not provided by tool on CLI. Please update this string when bumping container versions.
    def MERQURY_VERSION = '8f3ab706e4cf4d7b7d1dfe5739859e3ebd26c494' // WARN: Version information not provided by tool on CLI. Please update this string when bumping container versions.
    """
    KatComp \\
        $args \\
        -T$task.cpus \\
        ${fastk1_ktab.find{ it.toString().endsWith(".ktab") }} \\
        ${fastk2_ktab.find{ it.toString().endsWith(".ktab") }} \\
        $prefix

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        fastk: $FASTK_VERSION
        merquryfk: $MERQURY_VERSION
        r: \$( R --version | sed '1!d; s/.*version //; s/ .*//' )
    END_VERSIONS
    """
}
