# Copilot Instructions for chef-winrm

## Repository Overview

**chef-winrm** is a Ruby library that provides Windows Remote Management (WinRM) functionality for calling native objects in Windows. It supports running batch scripts, PowerShell scripts, and fetching WMI variables. As of version 2.0, PowerShell calls use the modern PowerShell Remoting Protocol (PSRP).

### Repository Structure

```
chef-winrm/
├── .github/                     # GitHub configuration and workflows
│   ├── workflows/              # CI/CD workflows (lint.yml, unit.yml)
│   ├── dependabot.yml          # Dependency update configuration
│   └── copilot-instructions.md # This file
├── bin/                        # Executable files
│   └── rwinrm                  # Command-line interface
├── lib/                        # Main library code
│   ├── chef-winrm.rb           # Main entry point
│   └── chef-winrm/             # Core library modules
│       ├── connection_opts.rb   # Connection configuration
│       ├── connection.rb        # Main connection class
│       ├── exceptions.rb        # Custom exceptions
│       ├── output.rb            # Output handling
│       ├── version.rb           # Version information
│       ├── http/                # HTTP transport implementation
│       │   ├── response_handler.rb
│       │   ├── transport_factory.rb
│       │   └── transport.rb
│       ├── psrp/                # PowerShell Remoting Protocol
│       │   ├── create_pipeline.xml.erb
│       │   ├── fragment.rb
│       │   ├── init_runspace_pool.xml.erb
│       │   ├── message_data.rb
│       │   ├── message_defragmenter.rb
│       │   ├── message_factory.rb
│       │   ├── message_fragmenter.rb
│       │   ├── message.rb
│       │   ├── powershell_output_decoder.rb
│       │   ├── receive_response_reader.rb
│       │   ├── session_capability.xml.erb
│       │   ├── uuid.rb
│       │   └── message_data/    # Message data types
│       ├── shells/              # Shell implementations
│       │   ├── base.rb
│       │   ├── cmd.rb
│       │   ├── power_shell.rb
│       │   ├── retryable.rb
│       │   └── shell_factory.rb
│       └── wsmv/                # WS-Management implementation
│           ├── base.rb
│           ├── cleanup_command.rb
│           ├── close_shell.rb
│           ├── command_output_decoder.rb
│           ├── command_output.rb
│           ├── command.rb
│           ├── configuration.rb
│           ├── create_pipeline.rb
│           ├── create_shell.rb
│           ├── header.rb
│           ├── init_runspace_pool.rb
│           ├── iso8601_duration.rb
│           ├── keep_alive.rb
│           ├── receive_response_reader.rb
│           ├── send_data.rb
│           ├── soap.rb
│           ├── wql_pull.rb
│           ├── wql_query.rb
│           └── write_stdin.rb
├── tests/                      # Test suite
│   ├── matchers.rb             # Test matchers
│   ├── integration/            # Integration tests
│   │   ├── auth_timeout_spec.rb
│   │   ├── cmd_spec.rb
│   │   ├── config-example.yml
│   │   ├── issue_59_spec.rb
│   │   ├── powershell_spec.rb
│   │   ├── spec_helper.rb
│   │   ├── transport_spec.rb
│   │   └── wql_spec.rb
│   └── spec/                   # Unit tests
│       ├── configuration_spec.rb
│       ├── connection_spec.rb
│       ├── exception_spec.rb
│       ├── output_spec.rb
│       ├── response_handler_spec.rb
│       ├── spec_helper.rb
│       ├── http/               # HTTP transport tests
│       ├── psrp/               # PSRP tests
│       ├── shells/             # Shell tests
│       ├── stubs/              # Test stubs and fixtures
│       └── wsmv/               # WSMV tests
├── chef-winrm.gemspec          # Gem specification
├── Gemfile                     # Bundle dependencies
├── Rakefile                    # Build tasks
├── README.md                   # Documentation
├── LICENSE                     # Apache 2.0 license
├── changelog.md                # Version history
├── appveyor.yml                # AppVeyor CI configuration
├── Vagrantfile                 # Development VM configuration
├── WinrmAppveyor.psm1          # PowerShell module for CI
└── preamble                    # License preamble
```

## Jira Integration Workflow

When a Jira ID is provided in the task description:

1. **Fetch Jira Issue Details**: Use the atlassian-mcp-server MCP server to fetch issue details
2. **Read and Analyze**: Carefully read the Jira story, acceptance criteria, and requirements
3. **Plan Implementation**: Break down the requirements into actionable development tasks
4. **Implement**: Follow the standard development workflow outlined below

Example usage:
```bash
# Use MCP server to get Jira issue details
mcp_atlassian-mcp_getJiraIssue --cloudId=<cloud-id> --issueIdOrKey=<jira-id>
```

## Development Workflow

### Complete Task Implementation Workflow

1. **Initial Analysis**
   - Fetch and analyze Jira issue (if applicable)
   - Understand requirements and acceptance criteria
   - Identify affected components and files
   - Create implementation plan

2. **Branch Creation**
   - Create feature branch using Jira ID as branch name
   - Ensure clean working directory before starting

3. **Implementation**
   - Implement the required functionality
   - Follow Ruby best practices and existing code patterns
   - Ensure compatibility with supported Ruby versions (3.1+)
   - Add appropriate logging using the logging gem
   - Handle errors gracefully with custom exceptions

4. **Testing**
   - Create comprehensive unit tests for all new functionality
   - Ensure test coverage remains above 80%
   - Add integration tests for complex features
   - Run existing test suite to ensure no regressions
   - Test on multiple Ruby versions if applicable

5. **Documentation**
   - Update README.md if public API changes
   - Add inline documentation for new methods/classes
   - Update changelog.md with breaking changes or new features

6. **Quality Assurance**
   - Run cookstyle linting
   - Fix any style violations
   - Ensure all tests pass
   - Verify code coverage requirements

7. **Commit and Push**
   - Make atomic commits with clear messages
   - Include DCO sign-off in all commits
   - Push to feature branch

8. **Pull Request Creation**
   - Create PR using GitHub CLI
   - Include comprehensive description with HTML formatting
   - Link to Jira issue if applicable
   - Add appropriate labels

## Testing Requirements

### Coverage Standards
- **Minimum Coverage**: 80% overall test coverage
- **Unit Tests**: Required for all new classes and methods
- **Integration Tests**: Required for complex workflows and external integrations
- **Test Organization**: Follow existing structure in `tests/spec/` and `tests/integration/`

### Test Execution
```bash
# Run unit tests
bundle exec rake spec

# Run integration tests
bundle exec rake integration

# Run all tests
bundle exec rake test
```

### Test File Naming
- Unit tests: `tests/spec/<module>_spec.rb`
- Integration tests: `tests/integration/<feature>_spec.rb`
- Follow existing naming conventions

## DCO Compliance Requirements

All commits must include a Developer Certificate of Origin (DCO) sign-off:

```bash
git commit -s -m "Your commit message"
```

The DCO sign-off certifies that you have the right to submit the code under the project's license. The sign-off appears as:

```
Signed-off-by: Your Name <your.email@example.com>
```

**Important**: All commits must include this sign-off. PRs with unsigned commits will be rejected.

## GitHub Workflow Integration

### Available Labels
The repository uses the following GitHub labels:
- `bug`: Something isn't working
- `documentation`: Improvements or additions to documentation
- `duplicate`: This issue or pull request already exists
- `enhancement`: New feature or request
- `good first issue`: Good for newcomers
- `help wanted`: Extra attention is needed
- `invalid`: This doesn't seem right
- `oss-standards`: Related to OSS Repository Standardization
- `question`: Further information is requested
- `wontfix`: This will not be worked on

### CI/CD Workflows
- **Lint Workflow**: Runs cookstyle on all pull requests and main branch pushes
- **Unit Test Workflow**: Runs unit tests on Windows 2019/2022 with Ruby 3.1/3.4

## Pull Request Creation Workflow

### Using GitHub CLI

1. **Authenticate with GitHub**:
   ```bash
   gh auth login
   ```

2. **Create and Push Branch**:
   ```bash
   git checkout -b <jira-id>
   git add .
   git commit -s -m "Implement <feature description>

   Implements the requirements from <JIRA-ID>
   
   - Detailed change 1
   - Detailed change 2
   - Detailed change 3"
   git push origin <jira-id>
   ```

3. **Create Pull Request**:
   ```bash
   gh pr create --title "<Jira-ID>: Brief description of changes" \
     --body "$(cat <<EOF
   <h2>Summary</h2>
   <p>Brief description of what this PR accomplishes</p>
   
   <h2>Changes Made</h2>
   <ul>
   <li>Detailed change 1</li>
   <li>Detailed change 2</li>
   <li>Detailed change 3</li>
   </ul>
   
   <h2>Testing</h2>
   <ul>
   <li>Added unit tests for new functionality</li>
   <li>Verified integration tests pass</li>
   <li>Test coverage maintained above 80%</li>
   </ul>
   
   <h2>Jira Reference</h2>
   <p>Implements: <a href="https://your-jira-instance/browse/<JIRA-ID>"><JIRA-ID></a></p>
   EOF
   )" \
     --label "enhancement" \
     --assignee @me
   ```

### PR Description Template
All PR descriptions should include:
- **Summary**: Clear description of changes
- **Changes Made**: Bulleted list of specific changes
- **Testing**: Description of test coverage and validation
- **Jira Reference**: Link to associated Jira issue (if applicable)
- **Breaking Changes**: Any backwards compatibility concerns

## Prompt-Based Development Approach

### Step-by-Step Guidance
After each development step, provide:
1. **Summary**: What was completed in the current step
2. **Next Step**: Clear description of the upcoming task
3. **Remaining Steps**: Overview of what's left to complete
4. **Continuation Prompt**: Ask user if they want to proceed with the next step

### Example Progress Update
```
✅ Step 2 Complete: Implementation
- Added new ConnectionManager class in lib/chef-winrm/connection_manager.rb
- Implemented retry logic with exponential backoff
- Added error handling for network timeouts

📋 Next Step: Create Unit Tests
- Create tests/spec/connection_manager_spec.rb
- Test retry logic and error scenarios
- Verify integration with existing Connection class

🔄 Remaining Steps:
- Integration testing
- Documentation updates
- PR creation

❓ Would you like to continue with creating the unit tests?
```

### Workflow Checkpoints
Provide checkpoints at:
- After initial analysis and planning
- After each major implementation phase
- Before and after testing
- Before PR creation
- After PR submission

## Code Quality Standards

### Ruby Style Guidelines
- Follow cookstyle/chefstyle conventions
- Use Ruby 3.1+ syntax and features
- Prefer explicit returns and clear variable names
- Use meaningful method and class names

### Architecture Patterns
- Follow existing patterns in the codebase
- Use dependency injection for testability
- Implement proper error handling and logging
- Maintain separation of concerns

### Dependencies
- Minimize new external dependencies
- Use existing gems when possible
- Ensure compatibility with supported Ruby versions
- Document any new dependencies in README.md

## Prohibited Modifications

Do not modify the following files without explicit approval:
- `chef-winrm.gemspec` (version changes only)
- `.github/workflows/*.yml` (CI configuration)
- `LICENSE` (legal document)
- `Rakefile` (build configuration)

## MCP Server Integration

### Atlassian MCP Server Usage
Use the `atlassian-mcp-server` for Jira operations:

```bash
# Get issue details
mcp_atlassian-mcp_getJiraIssue --cloudId=<cloud-id> --issueIdOrKey=<issue-key>

# Search issues
mcp_atlassian-mcp_search --query="<search-terms>"

# Add comments
mcp_atlassian-mcp_addCommentToJiraIssue --cloudId=<cloud-id> --issueIdOrKey=<issue-key> --commentBody="<comment>"

# Transition issues
mcp_atlassian-mcp_transitionJiraIssue --cloudId=<cloud-id> --issueIdOrKey=<issue-key> --transition=<transition-id>
```

### Authentication
Ensure proper authentication is configured for the MCP server before attempting Jira operations.

## Support and Troubleshooting

### Common Issues
- **WinRM Connection Errors**: Check endpoint configuration and authentication
- **PowerShell Execution**: Verify PSRP protocol support on target system
- **Test Failures**: Ensure Windows VM is properly configured for integration tests

### Debug Information
Enable debug logging for troubleshooting:
```ruby
conn = WinRM::Connection.new(opts)
conn.logger.level = :debug
```

### Getting Help
- Check existing issues and documentation
- Run tests to identify specific failures
- Use appropriate GitHub labels when creating issues
- Provide complete error messages and steps to reproduce

## AI-Assisted Development & Compliance

- ✅ Create PR with `ai-assisted` label (if label doesn't exist, create it with description "Work completed with AI assistance following Progress AI policies" and color "9A4DFF")
- ✅ Include "This work was completed with AI assistance following Progress AI policies" in PR description

### Jira Ticket Updates (MANDATORY)

- ✅ **IMMEDIATELY after PR creation**: Update Jira ticket custom field `customfield_11170` ("Does this Work Include AI Assisted Code?") to "Yes"
- ✅ Use atlassian-mcp tools to update the Jira field programmatically
- ✅ **CRITICAL**: Use correct field format: `{"customfield_11170": {"value": "Yes"}}`
- ✅ Verify the field update was successful

### Documentation Requirements

- ✅ Reference AI assistance in commit messages where appropriate
- ✅ Document any AI-generated code patterns or approaches in PR description
- ✅ Maintain transparency about which parts were AI-assisted vs manual implementation

### Workflow Integration

This AI compliance checklist should be integrated into the main development workflow Step 4 (Pull Request Creation):

```
Step 4: Pull Request Creation & AI Compliance
- Step 4.1: Create branch and commit changes WITH SIGNED-OFF COMMITS
- Step 4.2: Push changes to remote
- Step 4.3: Create PR with ai-assisted label
- Step 4.4: IMMEDIATELY update Jira customfield_11170 to "Yes"
- Step 4.5: Verify both PR labels and Jira field are properly set
- Step 4.6: Provide complete summary including AI compliance confirmation
```

- **Never skip Jira field updates** - This is required for Progress AI governance
- **Always verify updates succeeded** - Check response from atlassian-mcp tools
- **Treat as atomic operation** - PR creation and Jira updates should happen together
- **Double-check before final summary** - Confirm all AI compliance items are completed

### Audit Trail

All AI-assisted work must be traceable through:

1. GitHub PR labels (`ai-assisted`)
2. Jira custom field (`customfield_11170` = "Yes")
3. PR descriptions mentioning AI assistance
4. Commit messages where relevant

---

*This document serves as the complete guide for AI-assisted development on the chef-winrm repository. Follow these instructions to ensure consistent, high-quality contributions.*
