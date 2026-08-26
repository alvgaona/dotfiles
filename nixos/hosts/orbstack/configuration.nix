# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, modulesPath, rewire, ... }:

{
  imports =
    [
      # Include the default lxd configuration.
      "${modulesPath}/virtualisation/lxc-container.nix"
      # Copy of the OrbStack-generated file. The original in /etc/nixos is regenerated and
      # would be lost; re-copy it after an OrbStack upgrade changes it.
      ./orbstack.nix
      # Portable, hardware-agnostic settings shared with other machines.
      ../../common.nix
    ];

  networking.hostName = "nixos";

  users.users.enjin = {
    uid = 501;
    extraGroups = [ "wheel" "orbstack" "audio" ];

    # simulate isNormalUser, but with an arbitrary UID
    isSystemUser = true;
    group = "users";
    createHome = true;
    home = "/home/enjin";
    homeMode = "700";
    useDefaultShell = true;
    # Kept out of git: this repo is public. Create with
    #   mkpasswd -m yescrypt | sudo tee /etc/nixos/enjin.passwd && sudo chmod 600 /etc/nixos/enjin.passwd
    hashedPasswordFile = "/etc/nixos/enjin.passwd";
  };

  security.sudo.wheelNeedsPassword = false;

  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.displayManager.defaultSession = "xfce";

  services.xrdp = {
    enable = true;
    defaultWindowManager = "xfce4-session";
    openFirewall = true;
  };

  environment.systemPackages = [
    pkgs.ghostty
    pkgs.unstable.zed-editor
    rewire.packages.aarch64-linux.default
  ];

  # This being `true` leads to a few nasty bugs, change at your own risk!
  users.mutableUsers = false;

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
  };

  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  # Extra certificates from OrbStack.
  security.pki.certificates = [
    ''
      -----BEGIN CERTIFICATE-----
MIIDFDCCAfygAwIBAgIEsidTHTANBgkqhkiG9w0BAQsFADAZMRcwFQYDVQQDDA5B
dXRvZmlybWEgUk9PVDAeFw0yNjAxMTQxMTA2MzZaFw0zNjAxMTIxMTA2MzZaMBkx
FzAVBgNVBAMMDkF1dG9maXJtYSBST09UMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAtsvyjGb1F15sTYkh5qOp7PlcdEpyFo6oc1qSTdod2pYGP79ArXkh
FdgUWp44J/WrSI0XL/Nf1pILpwfRV1w8TS9KZ1W+eUj5Ir8ByQxsfhgpUP7KO0UE
M98jiOW/bw5oPB2onQXMne0g1O9RLAl3eLCUeUMBYtikaCoRz1JNp+Jsl7ankpK3
B/sDRHmQ+H7or+2qWtr0IEX9F7rdpbbawcOhNqp2DbJmrbUfN7yTSI5clzBpjAEb
AVlFmzOC7KMhWP5FfJ+X+ZLSXNZ7Np01uiYS/E64eQl74tkS/PmsceeKD5HL0sLQ
a5GFXMvHTemMbOlSMQ1329NZtHkxYOf1dQIDAQABo2QwYjAdBgNVHQ4EFgQU/uwm
uGNJ9m9XS05XvathMQcCEX8wDwYDVR0TAQH/BAUwAwEB/zALBgNVHQ8EBAMCAbYw
IwYDVR0lBBwwGgYIKwYBBQUHAwEGCCsGAQUFBwMCBgRVHSUAMA0GCSqGSIb3DQEB
CwUAA4IBAQC2cxY4XQ6XsQnv9OCT0aNU/ZAckbnnPS1J1M1RuVhoxBkj+ROqDOpm
TataS7kTcDO5CwEa+LvJY+Bhgqr2geBIn7xMXwOnEUuJFNnR7Fg3UdE2Fu9F3Pls
7tpe1uwcKckRfQezAw8H0HlC7vQXMG2QZaZiYvqyF2AHQbPv8AEwcI7KjkyEmaK4
8VThQGx46aUmUNt5tSEQ+P72+hhM6GG+qpg/GTD7x9m9tSL14rwD8LV3/xbRyZLA
zlECxZZUq9h3v1byhUFpgnl0u9E151WS3w9fefisfKJgGy6FYNYmK9Peaxg6c9jx
lbZfX87C+7tInCt5iTHi2hglTs6WO4EM
-----END CERTIFICATE-----

-----BEGIN CERTIFICATE-----
MIIDHzCCAgegAwIBAgIEPswM1TANBgkqhkiG9w0BAQsFADAZMRcwFQYDVQQDDA5B
dXRvZmlybWEgUk9PVDAeFw0yNjAxMTQxMTA2MzZaFw0zNjAxMTIxMTA2MzZaMBQx
EjAQBgNVBAMMCTEyNy4wLjAuMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAOp176CTVZZrIaVbfKPBoK+P7n0+3rmbj/nIMSSnxIgACQD/RaZdX7RyE3LR
QZaxVnOvJ9HeTRvCZbIub+uoFkppfwxHakoY5Jt2ijCD7/RsEsxNhobzeWmdBB9S
Uk8YU5XehDBJULIzPIxu2c7wG1W9xuHFWnEObq/rcLoOz/LkDe2x/e5v8de3CLlh
nE7MQD4q6029UE6MNeCVOVhYian4wo3n4thRiP2SO/pnM5jU/J/LN2Ysn5ukbe1E
/uCRTKhsjk83P4ZeOWf9V2oNCcpHr6T5CKwOwr0mFPLNSw/qheIAFFENRDRisr3G
pbNU6LC3f1VzM5Uw5/0qPUtSWwECAwEAAaN0MHIwHQYDVR0OBBYEFDbG3i2FZpCS
XY+NA82coxAyCbbWMAkGA1UdEwQCMAAwHwYDVR0jBBgwFoAU/uwmuGNJ9m9XS05X
vathMQcCEX8wJQYDVR0RBB4wHIcEfwAAAYIJMTI3LjAuMC4xgglsb2NhbGhvc3Qw
DQYJKoZIhvcNAQELBQADggEBAA6+Xvnc4WQL8818CzTtXkVpR+f/dn4tshYTaOPx
xz/w1FePJlLolBZiBngxJUPS0qfdn5JkPeYWAw1i4kPOuY2mLF0HFf3mgmzfpU0q
2bjG0xDTHq0yFF/Ox2uB/5jo50ZOPIIlRX+YZx5I36jhi/xLDf2HAEsWQ7t3tvf1
pHpWDdZq6sHYFOPJ6KlexzaE079AqEiV+wEhw4xXceTSgc54/1//btHMZUVIvhdM
/U9SMx7VMW/3XhnoAZOXNPXKnziJihyLmLCHBqm5JKRxaXoG2OizMeDSHubzp7Kj
WGSlMOl4hn+QJFlzGWq3Mmb+B6RjfkPD2ADsAgRLjEWkZG8=
-----END CERTIFICATE-----

-----BEGIN CERTIFICATE-----
MIICDDCCAbKgAwIBAgIQeHnoeeoAH9XdABDlUs+qMDAKBggqhkjOPQQDAjBmMR0w
GwYDVQQKExRPcmJTdGFjayBEZXZlbG9wbWVudDEeMBwGA1UECwwVQ29udGFpbmVy
cyAmIFNlcnZpY2VzMSUwIwYDVQQDExxPcmJTdGFjayBEZXZlbG9wbWVudCBSb290
IENBMB4XDTI2MDMwOTAxMDk1MloXDTM2MDMwOTAxMDk1MlowZjEdMBsGA1UEChMU
T3JiU3RhY2sgRGV2ZWxvcG1lbnQxHjAcBgNVBAsMFUNvbnRhaW5lcnMgJiBTZXJ2
aWNlczElMCMGA1UEAxMcT3JiU3RhY2sgRGV2ZWxvcG1lbnQgUm9vdCBDQTBZMBMG
ByqGSM49AgEGCCqGSM49AwEHA0IABJFX6M0Qlz8yBIlqdONOp2+60VyhFLLSWlEn
KHcUXB28AFGUt8aZIEQMTH0B4H5LcaxhPd3zkJFA6aBG9CDEwu6jQjBAMA4GA1Ud
DwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBRZ/HWdzpGW6IIr
Z41yN18eVrSPXTAKBggqhkjOPQQDAgNIADBFAiEA4o74Q5tte6xvupua0iLOZshn
9ONo0b74+mM8amFO/hkCIGPhZoeQe+4yhZcoo8Dhbb+CqQ5xJkCiuq6PWDBppYNJ
-----END CERTIFICATE-----

    ''
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
