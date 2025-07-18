# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the goldentooth.pi_config role.

## Overview

This role configures Raspberry Pi-specific settings including hardware optimization, thermal management, and Pi-specific system configuration.

## Purpose

- Configure Raspberry Pi hardware settings
- Set up thermal management and fan control
- Configure Pi-specific system settings
- Optimize performance for cluster workloads
- Set up overclocking and voltage settings

## Files

- `tasks/main.yaml`: Main task file

## Key Features

### Hardware Configuration
- Configures GPIO settings for hardware control
- Sets up fan control for thermal management
- Configures overclocking for performance

### Thermal Management
- Sets up temperature-based fan control
- Configures thermal throttling settings
- Optimizes for continuous operation

### System Optimization
- Configures locale and timezone settings
- Sets up keyboard and country settings
- Optimizes boot and system settings

### Performance Tuning
- Configures overclocking frequencies
- Sets appropriate voltage levels
- Optimizes for cluster workloads

## Dependencies

- Requires Raspberry Pi hardware
- Uses raspi-config for configuration
- Requires appropriate permissions for hardware access
- Depends on Pi-specific system tools

## Variables

Key variables from inventory:
- `pi.fan_gpio`: GPIO pin for fan control
- `pi.fan_temp`: Temperature threshold for fan activation
- `pi.locale`: System locale setting
- `pi.timezone`: Timezone configuration
- `pi.overclock_freq`: Overclocking frequency
- `pi.overclock_voltage`: Overclocking voltage

## Usage

This role is typically called via the pi_config playbook:
```yaml
- { role: 'goldentooth.pi_config' }
```

## Integration

Works with:
- Hardware monitoring systems
- Thermal management across cluster
- Performance optimization for cluster services
- System configuration management

## Security Considerations

- Secure hardware configuration
- Proper permissions for GPIO access
- Safe overclocking settings
- Thermal protection mechanisms
- Secure system configuration