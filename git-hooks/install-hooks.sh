#!/bin/bash

# ReCorReCt Git Hooks Installation Script
# This script installs the ReCorReCt text transformation hooks into a git repository

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Function to check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository. Please run this script from within a git repository."
        exit 1
    fi
}

# Function to get the git hooks directory
get_hooks_dir() {
    git rev-parse --git-dir | xargs -I {} echo "{}"/hooks
}

# Function to backup existing hooks
backup_existing_hook() {
    local hook_name="$1"
    local hooks_dir="$2"
    local existing_hook="$hooks_dir/$hook_name"

    if [ -f "$existing_hook" ]; then
        local backup_name="${existing_hook}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$existing_hook" "$backup_name"
        print_warning "Backed up existing $hook_name hook to: $(basename "$backup_name")"
        return 0
    fi
    return 1
}

# Function to install a hook
install_hook() {
    local hook_name="$1"
    local source_dir="$2"
    local hooks_dir="$3"

    local source_hook="$source_dir/$hook_name"
    local target_hook="$hooks_dir/$hook_name"

    if [ ! -f "$source_hook" ]; then
        print_error "Source hook not found: $source_hook"
        return 1
    fi

    # Backup existing hook if it exists
    backup_existing_hook "$hook_name" "$hooks_dir"

    # Copy the hook
    cp "$source_hook" "$target_hook"
    chmod +x "$target_hook"

    print_success "Installed $hook_name hook"
    return 0
}

# Function to install the transformation script
install_transform_script() {
    local source_dir="$1"
    local hooks_dir="$2"

    local source_script="$source_dir/transform-text.js"
    local target_script="$hooks_dir/transform-text.js"

    if [ ! -f "$source_script" ]; then
        print_error "Transformation script not found: $source_script"
        return 1
    fi

    cp "$source_script" "$target_script"
    chmod +x "$target_script"

    print_success "Installed transformation script"
    return 0
}

# Function to check Node.js availability
check_nodejs() {
    if ! command -v node >/dev/null 2>&1; then
        print_warning "Node.js not found in PATH"
        print_info "The hooks will work but transformations will be skipped without Node.js"
        print_info "Install Node.js to enable ReCorReCt transformations"
        return 1
    else
        local node_version=$(node --version)
        print_success "Node.js found: $node_version"
        return 0
    fi
}

# Function to test the transformation
test_transformation() {
    local hooks_dir="$1"
    local transform_script="$hooks_dir/transform-text.js"

    if [ ! -f "$transform_script" ]; then
        print_error "Transform script not installed"
        return 1
    fi

    # Create a temporary test file
    local test_file=$(mktemp)
    echo "test message with research and return values" > "$test_file"

    print_info "Testing transformation..."
    if node "$transform_script" "$test_file"; then
        local result=$(cat "$test_file")
        print_info "Test input: 'test message with research and return values'"
        print_info "Test output: '$result'"

        if [[ "$result" == *"ReSearch"* ]] && [[ "$result" == *"ReTurn"* ]]; then
            print_success "Transformation test passed!"
        else
            print_warning "Transformation test produced unexpected results"
        fi
    else
        print_error "Transformation test failed"
    fi

    # Clean up
    rm -f "$test_file"
}

# Main installation function
main() {
    print_info "ReCorReCt Git Hooks Installation"
    print_info "================================"

    # Check if we're in a git repository
    check_git_repo

    # Get the directory where this script is located
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Get the git hooks directory
    local hooks_dir=$(get_hooks_dir)

    print_info "Installing hooks to: $hooks_dir"

    # Create hooks directory if it doesn't exist
    mkdir -p "$hooks_dir"

    # Install the transformation script
    if ! install_transform_script "$script_dir" "$hooks_dir"; then
        print_error "Failed to install transformation script"
        exit 1
    fi

    # Install hooks
    local hooks_to_install=("commit-msg" "prepare-commit-msg")
    local installed_count=0

    for hook in "${hooks_to_install[@]}"; do
        if install_hook "$hook" "$script_dir" "$hooks_dir"; then
            ((installed_count++))
        else
            print_error "Failed to install $hook hook"
        fi
    done

    if [ $installed_count -eq 0 ]; then
        print_error "No hooks were installed successfully"
        exit 1
    fi

    print_success "Successfully installed $installed_count hook(s)"

    # Check Node.js
    check_nodejs

    # Test the transformation
    test_transformation "$hooks_dir"

    print_info ""
    print_success "Installation complete!"
    print_info "ReCorReCt text transformations will now be applied to your commit messages."
    print_info ""
    print_info "To test, try committing with a message containing 'research' or 'return'."
    print_info "These words will be automatically transformed to 'ReSearch' and 'ReTurn'."
    print_info ""
    print_info "To uninstall, simply delete the hooks from: $hooks_dir"
}

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        echo "ReCorReCt Git Hooks Installation Script"
        echo ""
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --version, -v  Show version information"
        echo ""
        echo "This script must be run from within a git repository."
        echo "It will install git hooks that apply ReCorReCt text transformations"
        echo "to commit messages, transforming 're' + letter patterns to 'Re' + capitalized letter."
        exit 0
        ;;
    --version|-v)
        echo "ReCorReCt Git Hooks v1.0.0"
        exit 0
        ;;
    "")
        # No arguments, proceed with installation
        main
        ;;
    *)
        print_error "Unknown option: $1"
        print_info "Use --help for usage information"
        exit 1
        ;;
esac
