# Security Policy

## Supported Versions

Currently, the following versions of Restaurant Order Management API are supported with security updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.x     | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take the security of this project seriously. If you believe you have found a security vulnerability, please report it to us privately.

**Please do not create a public GitHub issue for security-related topics.**

Instead, please send an email to:
- [your-email@example.com] (Please update this in your fork or local copy)

### What to include in your report:
- A description of the vulnerability.
- Steps to reproduce the issue.
- Potential impact of the vulnerability.
- Any suggested fixes or mitigations.

### Our process:
1. We will acknowledge your report within 48 hours.
2. We will investigate the issue and determine the risk level.
3. We will work on a fix and coordinate a release.
4. We will credit you for your discovery (unless you prefer to remain anonymous).

## Security Best Practices for Users
- **Authentication**: This API does not include built-in user authentication. Please use an API gateway or proxy (like NGINX, AWS API Gateway, or Kong) to handle authentication and authorization.
- **HTTPS**: Always use HTTPS in production environments.
- **Rate Limiting**: The included `rack-attack` configuration is a starting point. Adjust the limits based on your production needs.
- **Environment Variables**: Never commit sensitive information (like database passwords or master keys) to your repository. Use environment variables.
