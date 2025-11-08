# Changelog

All notable changes to T-REX will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.1.1] - 2025-10-21

### Fixed
- Fixed xrpn dependency version from ~> 3.0 to ~> 2.7 (latest available on RubyGems)
- Resolves installation error reported by users on IRC

## [4.1.0] - 2025-10-21

### Added
- ENG (engineering notation) mode where exponents are always multiples of 3
- Ctrl+E key binding to toggle ENG mode on/off
- ENG indicator in status line when mode is active
- Persistent ENG mode state saved to ~/.t-rex.conf

### Changed
- Updated help text to document ENG mode usage
- Updated README with ENG mode documentation and examples

### Fixed
- Minor formatting improvements in key panel layout

## [4.0.0] - 2024-08-15

### Changed
- Breaking change: requires rcurses 6.0.0+ with explicit initialization for Ruby 3.4+ compatibility
- Added explicit Rcurses.init! call for compatibility

### Added
- Animated T-REX RPN calculator logo
- Badges to README
- Clear break after logo to prevent text collision

## [3.0.0] - 2024-08-15

### Added
- Major XRPN integration release
- Hybrid calculation modes (T-REX and XRPN)
- Enhanced mathematical functions via XRPN
- Program execution environment (P key)
- Program editor (E key)
- Base conversions (hex, binary, octal, decimal)
- Factorial safety (max 170!)
- Comprehensive scrolling support in P and E modes

## [2.3.3] - 2024-07-05

### Fixed
- Cursor positioning issues

## [2.3.2] - Earlier

### Fixed
- Fix for rcurses compatibility

## [2.3.1] - Earlier

### Fixed
- Fix for rcurses compatibility
