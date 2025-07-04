# Release & Deployment Guide

## Release Steps

1. Run all tests and lint checks (`flutter analyze`)
2. Update `CHANGELOG.md` and bump the version in `pubspec.yaml`
3. Commit and push changes.
4. Tag the release: `git tag v1.0.0 && git push --tags`
5. Deploy via GitHub Actions or CLI (`flutter build ...`)

## Deploy Targets

- Android: Play Store (follow Google submission process)
- Web: Firebase Hosting or Vercel
- Windows: MSIX package

## Rollback

- Tag and re-deploy previous stable version if required.
