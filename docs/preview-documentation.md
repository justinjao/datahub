# Okteto Developer Setup for cBioPortal Maintainers

This documentation outlines the exact work performed to setup the Okteto preview pipeline. If this were ever to be set up again from scratch, following these steps should replicate the existing infrastructure.

In case just the images needs to be rebuilt (e.g. if a newer cbioportal version is released and must be used), a simple script (`preview_init.sh`) is available to replicate rebuilding the image (steps 4 - 7)

## One time Setup (to be done by maintainer):

1. Okteto Account Creation - Visit [Here](https://www.okteto.com/try-free/) and link a GitHub account. Note that the account must be linked to a business email (i.e. non-gmail account).
2. Install the Okteto CLI and initialize the context as per instructions [here](https://www.okteto.com/docs/getting-started/#installing-okteto-cli).

3. Generate Okteto Personal Access Token (PAT) as per instructions [here](https://www.okteto.com/docs/cloud/personal-access-tokens/)


4. Clone the `cbioportal-docker-compose` repository and run the initialization script, `./init.sh` in the root directory.

5. Remove all instances of the `:ro` text within the `docker-compose.yml` file, as this is not supported by Okteto.

6. Run `okteto context use https://cloud.okteto.com`, to initialize the namespace Okteto will use.

7. Run `okteto build` to build and push an initial *cbioportal* and *cbioportal-database* image to the Okteto Registry with the initialized configuration present.

In Datahub repo:

8. Add new secret variable OKTETO_TOKEN using PAT to datahub repo
9. Add new secret variable OKTETO_URL (https://cloud.okteto.com) to datahub repo
10. In the repo settings > Code and automation > Actions > General > Workflow Permissions, enable workflow read-write permissions to allow Okteto to post messages in a PR.
11. Add new workflow file (`preview.yml`) from PR to .github folder of datahub repository.
12. Add files from PR to setup infrastructure for re-building image in PR. Specifically:
    a. `mkdir preview`
    b. `mkdir preview/cbioportal-docker-compose`
    c. `mkdir preview/cbioportal-docker-compose/study`
    d. Add modified `docker-compose.yml` file in Step 5 (i.e. a file with `:ro` removed).
    e. Add a `.env` file containing the images to be built.
12. If necessary, rename all instances of the namespace to the current desired user (e.g. justinjao) in `preview.yml` and `.env`.

Following this setup, subsequent PRs should correctly trigger a staging environment with the new studies imported.



