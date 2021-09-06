# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v1.0.1 - Sep, 2021

- Fix `install` command to fetch changes before checking out a branch on both MathType and Quizzes suites. 
- Fix `install` command to fetch changes before checking out a Moodle Release branch. 
- Set `Moodle3_11` as default branch when not informed.
- Improve the "MathType Moodle Plugins Suite" software development cycle.

## v1.0.0 - Jul 19, 2021

- Support for Wiris MathType and Wiris Quizzes Moodle plugins suites.
- Initial commit
  - Commands to compile and build a customized Moodle instance using docker.
  - Dependency management: download moodle-docker. 
  - Support for linux and OSx systems via bash commands.
  - Document README.md
      - Quickstart
      - How to test

## [Unreleased]

...

## [Feature-request]

- Support to Windows systems via `cmd` file.
- Decide wether to add a PHP automated/build tool like [phing](https://www.phing.info/) or or [robo](https://robo.li/). (?)

