/**
 * Checkout code from the specified repository
 *
 * @param repoUrl (String) - The Git repository URL
 * @param branch (String) - The branch to checkout (default: 'main')
 * @param credentialsId (String) - Jenkins credentials ID for authentication (optional)
 * @param shallowClone (boolean) - Whether to perform a shallow clone (default: true)
 * @return (boolean) - True if the checkout is successful
 */
def call(Map params = [:]) {
    def repoUrl = params.get('repoUrl', '')
    def branch = params.get('branch', 'main')
    def credentialsId = params.get('credentialsId', '')
    def shallowClone = params.get('shallowClone', true)
    
    if (!repoUrl) {
        error "Repository URL ('repoUrl') is required for checkout"
    }
    
    try {
        echo "Checking out code from ${repoUrl} on branch ${branch}"
        
        def scmConfig = [
            $class: 'GitSCM',
            branches: [[name: "*/${branch}"]],
            userRemoteConfigs: [[
                url: repoUrl,
                credentialsId: credentialsId
            ]],
            extensions: shallowClone ? [[$class: 'CloneOption', shallow: true, depth: 1]] : []
        ]
        
        checkout(scmConfig)
        echo "Checkout successful!"
        return true
    } catch (Exception e) {
        echo "Error during checkout: ${e.message}"
        currentBuild.result = 'FAILURE'
        throw e
    }
}
