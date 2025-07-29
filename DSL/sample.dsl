workspace "Cloud-Hosted Container Deployment" "A C4 System Landscape diagram representing a typical cloud-hosted, container-based service deployment pipeline." {

    model {
        // ========== Actors (Persons) ==========
        // The person who writes and submits the code.
        developer = person "Developer" "Submits application code." "Dev"

        // The person responsible for verifying tests and deploying to production.
        opsEngineer = person "Ops Engineer" "Verifies tests and manages production deployments." "Operations"

        // A malicious actor attempting to compromise the pipeline.
        threatActor = person "Threat Actor" "Attempts to compromise the pipeline or running services." "Attacker" {
            tags "ThreatActor"
        }


        // ========== Software Systems ==========
        // The system that stores the source code (e.g., Git, GitHub, GitLab).
        versionControl = softwareSystem "Version Control" "Stores application source code and tracks changes." "VCS" {
            tags "VCS"
        }

        // The tools used to build the container image (e.g., Docker, Kaniko).
        buildTools = softwareSystem "Build Tools" "Tools used by the CI System to compile code and create a container image." "Tools" {
            tags "Tools"
        }

        // The CI system orchestrates the build and test process.
        ciSystem = softwareSystem "CI System" "Periodically builds, tests, and uploads new containers." "CI/CD" {
            tags "CI"
        }

        // The registry where container images are stored (e.g., Docker Hub, ECR, GCR).
        containerRegistry = softwareSystem "Container Registry" "Stores and versions container images." "Registry" {
            tags "Registry"
        }

        // The environment for running automated tests.
        testEnvironment = softwareSystem "Test Environment" "An isolated environment where the CI system runs automated tests against the new container." "Environment" {
            tags "Environment"
        }

        // The live production environment serving end-users.
        productionEnvironment = softwareSystem "Production Environment" "The live environment where the verified container is deployed and runs." "Environment" {
            tags "Environment"
        }


        // ========== Relationships (Based on numbered steps in the diagram) ==========

        // 1. Dev submits code
        developer -> versionControl "Submits code to" "Step 1"

        // 2. Periodically, CI system builds a new Docker container
        ciSystem -> versionControl "Pulls code from" "Step 2"
        ciSystem -> buildTools "Builds container using" "Step 2"
        ciSystem -> containerRegistry "Uploads new container to" "Step 2 (cont'd)"

        // 3. CI system detects a new container and runs it in a testing environment
        ciSystem -> containerRegistry "Detects new container in" "Step 3"
        ciSystem -> testEnvironment "Runs tests in" "Step 3"

        // 4. Ops engineer verifies tests and deploys
        opsEngineer -> testEnvironment "Verifies successful tests from" "Step 4"
        opsEngineer -> productionEnvironment "Deploys container to" "Step 4"
        productionEnvironment -> containerRegistry "Pulls container from" "Step 4"

        // ========== Threat Actor Relationships ==========
        threatActor -> versionControl "Injects malicious code into" "Attack Vector"
        threatActor -> containerRegistry "Pushes poisoned container to" "Attack Vector"
        threatActor -> productionEnvironment "Attacks running services in" "Attack Vector"
    }

    views {
        // A System Landscape view is perfect for showing how multiple systems interact.
        systemLandscape "DeploymentPipeline" {
            include * 
            autolayout lr 

            title "Typical Cloud-Hosted Container-Based Service Deployment"
            description "A landscape view illustrating the systems and actors involved in a CI/CD pipeline, including potential threats."
        }

        styles {
            element "Element" {
                color #ffffff
                fontSize 22
            }
            element "Person" {
                background #08427b
                shape Person
                width 350
            }
            element "ThreatActor" {
                background #d32f2f 
                color #ffffff
                shape Robot 
            }
            element "Software System" {
                background #1168bd
                shape RoundedBox
                width 400
                height 200
            }
            element "VCS" {
                // Style for Version Control System
                shape WebBrowser
                background #2d5b8b
            }
            element "Tools" {
                // Style for Build Tools
                shape Component
                background #999999
            }
            element "CI" {
                // Style for the CI System
                shape Robot
                background #00a884
            }
            element "Registry" {
                // Style for the Container Registry
                shape Cylinder
                background #854cac
            }
            element "Environment" {
                // Style for Test and Production Environments
                //shape Cloud
                background #438dd5
            }
        }
    }
}
