#include <ESPmDNS.h>
#include <WiFiManager.h>
#include <WiFiUdp.h>

#define MQ2pin 33

WiFiUDP udp;
WiFiManager wifiManager;

String mac2String(byte ar[]) {
  String s;
  for (byte i = 0; i < 6; ++i) {
    char buf[3];
    sprintf(buf, "%02X", ar[i]);
    s += buf;
    if (i < 5) s += ':';
  }
  return s;
}

void setup() {
  Serial.begin(9600);

  pinMode(MQ2pin, INPUT_PULLDOWN);

  wifiManager.resetSettings();
  bool res = wifiManager.autoConnect();

  if (!res) {
    Serial.println("Failed to connect");
  }

  if (mdns_init() != ESP_OK) {
    Serial.println("mDNS failed to start");
    return;
  }
}

void loop() {
  int numberOfServices = MDNS.queryService("_FLUTTER", "udp");

  if (numberOfServices < 1) {
    Serial.println("No service found...");
  };

  for (int i = 0; i < numberOfServices; i++) {
    String hostname = MDNS.hostname(i);
    IPAddress ip = MDNS.IP(i);

    uint64_t mac = ESP.getEfuseMac();

    String id = mac2String((byte*)&mac);

    if (digitalRead(MQ2pin) == LOW) {
      String msg = "{\"id\": \"" + id + "\",\"status\": \"active\"}";

      udp.beginPacket(ip, 5001);
      udp.print(msg);
      udp.endPacket();
    } else {
      String msg = "{\"id\": \"" + id + "\",\"status\": \"connected\"}";

      udp.beginPacket(ip, 5001);
      udp.print(msg);
      udp.endPacket();
    }

    Serial.print("Message sent to: [ Name: ");
    Serial.print(hostname);
    Serial.print(" , IP Address: ");
    Serial.print(ip.toString());
    Serial.println(" ]");
  }
}