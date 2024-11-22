// vars/checkoutCode.groovy

def call(Map config = [:]) {
    // Ensure mandatory configuration is provided
    def repoUrl = config.repoUrl ?: error("Repository URL is required")
    def branch = config.branch ?: 'main'  // Default to 'main' branch if not specified
    def credentialsId = config.credentialsId ?: ''  // Optional credentials for private repos

    try {
        echo "Checking out code from ${repoUrl} on branch ${branch}..."

        retry(3) {
            checkout([
                $class: 'GitSCM',
                branches: [[name: "*/${branch}"]],
                doGenerateSubmoduleConfigurations: false,
                extensions: [
                    // Optionally use shallow clone to improve performance
                    [$class: 'CloneOption', depth: config.depth ?: 1, noTags: false, shallow: true]
                ],
                userRemoteConfigs: [[
                    url: repoUrl,
                    credentialsId: credentialsId  // Use credentials if provided
                ]]
            ])
        }
        
        echo "Code checkout completed successfully."

    } catch (Exception e) {
        error "Code checkout failed: ${e.message}"
    }
}
