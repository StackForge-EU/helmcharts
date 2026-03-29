# Helm Charts

A collection of Helm charts for deploying applications on Kubernetes.

## Requirements

- Helm 3.x or later

## Charts

- [**calcom**](./charts/calcom/README.md) - Cal.com scheduling platform
- [**documenso**](./charts/documenso/README.md) - Documenso, the open-source DocuSign alternative
- [**docuseal**](./charts/docuseal/README.md) - DocuSeal, open-source document signing
- [**ghostcms**](./charts/ghostcms/README.md) - Ghost CMS publishing platform
- [**maxmind-geoip-api**](./charts/maxmind-geoip-api/README.md) - MaxMind GeoIP lookup API
- [**youtrack**](./charts/youtrack/README.md) - JetBrains YouTrack issue tracking platform

## Installation

Add the Helm repository:

```bash
helm repo add stackforge https://stackforge-eu.github.io/helmcharts
helm repo update
```

Read the documentation for each chart for installation instructions.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**Note:** Individual charts may use different licenses, for example if they are forked from other projects. Please check the LICENSE file in each chart directory for specific licensing information.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue for any bugs or feature requests.

## Contact

For questions or bug reports, please open an issue on the GitHub repository.
