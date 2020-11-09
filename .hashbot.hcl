behavior "pull_request_path_labeler" "cross_provider_labels" {
    label_map = {
        "documentation" = ["website/**/*"]
        "dependencies" = ["vendor/**/*"]
    }
}
