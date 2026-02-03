# Shadow Development Documentation

**Version:** 1.0
**Last Updated:** January 30, 2026

---

## Overview

This folder contains the complete professional documentation suite for building the Shadow health tracking application. These documents provide comprehensive specifications, standards, and implementation guides following Apple-level engineering practices.

---

## Document Index

### Core Specifications

| Document | Description |
|----------|-------------|
| [01_PRODUCT_SPECIFICATIONS.md](./01_PRODUCT_SPECIFICATIONS.md) | **Master document** - Complete product specification including all features, domain model, and requirements |
| [02_CODING_STANDARDS.md](./02_CODING_STANDARDS.md) | Mandatory coding standards for all development |
| [03_DESIGN_POLICIES.md](./03_DESIGN_POLICIES.md) | UI/UX guidelines and design system |
| [04_ARCHITECTURE.md](./04_ARCHITECTURE.md) | Technical architecture and patterns |

### Implementation Guides

| Document | Description |
|----------|-------------|
| [05_IMPLEMENTATION_ROADMAP.md](./05_IMPLEMENTATION_ROADMAP.md) | **Step-by-step build guide** - Phased approach from project setup to production |
| [06_TESTING_STRATEGY.md](./06_TESTING_STRATEGY.md) | 100% internal testing methodology |
| [07_NAMING_CONVENTIONS.md](./07_NAMING_CONVENTIONS.md) | Consistent naming across all layers |
| [08_OAUTH_IMPLEMENTATION.md](./08_OAUTH_IMPLEMENTATION.md) | OAuth credentials and implementation details |

### Reference Documents

| Document | Description |
|----------|-------------|
| [09_WIDGET_LIBRARY.md](./09_WIDGET_LIBRARY.md) | Centralized widget component documentation |
| [10_DATABASE_SCHEMA.md](./10_DATABASE_SCHEMA.md) | Complete database design |
| [11_SECURITY_GUIDELINES.md](./11_SECURITY_GUIDELINES.md) | Security and HIPAA compliance |
| [12_ACCESSIBILITY_GUIDELINES.md](./12_ACCESSIBILITY_GUIDELINES.md) | WCAG 2.1 Level AA compliance |
| [13_LOCALIZATION_GUIDE.md](./13_LOCALIZATION_GUIDE.md) | Internationalization implementation |

---

## Quick Start

### For New Engineers

1. Read [01_PRODUCT_SPECIFICATIONS.md](./01_PRODUCT_SPECIFICATIONS.md) to understand what we're building
2. Read [02_CODING_STANDARDS.md](./02_CODING_STANDARDS.md) - this is **mandatory**
3. Review [07_NAMING_CONVENTIONS.md](./07_NAMING_CONVENTIONS.md) for consistency
4. Follow [05_IMPLEMENTATION_ROADMAP.md](./05_IMPLEMENTATION_ROADMAP.md) for build sequence

### For OAuth Setup

1. See [08_OAUTH_IMPLEMENTATION.md](./08_OAUTH_IMPLEMENTATION.md) for credentials
2. Current Client IDs are documented with configuration examples

### For Testing

1. Read [06_TESTING_STRATEGY.md](./06_TESTING_STRATEGY.md)
2. Tests are **mandatory** - no feature ships without tests
3. Require 100% test coverage (see 02_CODING_STANDARDS.md Section 10.3)

---

## Key Principles

### Engineering Standards

1. **Test-As-You-Go**: Every feature has tests before commit
2. **Clean Architecture**: Presentation → Domain → Data
3. **Security First**: AES-256 encryption, HIPAA compliance
4. **Accessibility Always**: WCAG 2.1 Level AA minimum
5. **Consistency**: Follow naming conventions exactly

### Code Review Checklist

Before any PR:

- [ ] All tests passing
- [ ] New tests for new functionality
- [ ] Code follows naming conventions
- [ ] Dartdoc on public APIs
- [ ] No sensitive data in logs
- [ ] Accessibility requirements met
- [ ] flutter analyze clean

---

## OAuth Credentials Summary

| Platform | Client ID |
|----------|-----------|
| Desktop/macOS | `656246118580-nvu5ckn9l7vst8hmj8no3t7cb10egui3.apps.googleusercontent.com` |
| iOS | `656246118580-s9p6jcg8pcumirbrp3pmed49uft43th2.apps.googleusercontent.com` |

See [08_OAUTH_IMPLEMENTATION.md](./08_OAUTH_IMPLEMENTATION.md) for full details.

---

## Contact

**Email:** info@bluedomecolorado.com

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-30 | Development Team | Initial release |
