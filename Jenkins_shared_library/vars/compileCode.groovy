// vars/compileCode.groovy

def call(Map config = [:]) {
    try {
        // Detect the language based on config or project structure
        def language = config.language ?: detectLanguage()
        
        // Environment-specific configurations
        def buildEnv = config.env ?: 'production'
        echo "Building for environment: ${buildEnv}"

        // Set default build options, can be customized via config
        def buildOptions = config.buildOptions ?: []

        // Call the appropriate compilation method based on the language
        switch (language) {
            case 'java':
                compileJava(buildOptions)
                break
            case 'nodejs':
                compileNodeJs(buildOptions)
                break
            case 'python':
                compilePython(buildOptions)
                break
            default:
                error "Unsupported language: ${language}. Please configure a supported language."
        }
    } catch (Exception e) {
        // Fail the build with a clear error message
        error "Build failed: ${e.message}"
    }
}

// Method to detect language based on file structure
def detectLanguage() {
    if (fileExists('pom.xml')) {
        return 'java'
    } else if (fileExists('package.json')) {
        return 'nodejs'
    } else if (fileExists('requirements.txt')) {
        return 'python'
    } else {
        error "Unable to detect project language. Please specify it in the configuration."
    }
}

// Method to compile Java projects with retries
def compileJava(List options) {
    retry(3) {
        try {
            echo "Compiling Java project..."
            def mvnCmd = "mvn clean install"
            if (options) {
                mvnCmd += " ${options.join(' ')}"
            }
            sh mvnCmd
            echo "Java compilation completed successfully."
        } catch (Exception e) {
            error "Java compilation failed: ${e.message}"
        }
    }
}

// Method to compile Node.js projects with security and options
def compileNodeJs(List options) {
    retry(3) {
        try {
            echo "Compiling Node.js project..."
            def npmCmd = "npm install && npm run build"
            if (options) {
                npmCmd += " ${options.join(' ')}"
            }
            sh npmCmd
            echo "Node.js compilation completed successfully."
        } catch (Exception e) {
            error "Node.js compilation failed: ${e.message}"
        }
    }
}

// Method to compile Python projects with proper pip installation
def compilePython(List options) {
    retry(3) {
        try {
            echo "Setting up Python environment..."
            def pipCmd = "pip install -r requirements.txt"
            if (options) {
                pipCmd += " ${options.join(' ')}"
            }
            sh pipCmd
            echo "Python environment set up and ready."
        } catch (Exception e) {
            error "Python environment setup failed: ${e.message}"
        }
    }
}
