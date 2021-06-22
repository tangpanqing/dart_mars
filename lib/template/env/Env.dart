class Env {
  static String content = '''
#  db config
dbHost: localhost
dbPort: 3306
dbUser: root
dbPassword: root
dbName: example

#  ssl config
ssl: off
sslCertificate: cert/cert.pem
sslCertificateKey: cert/key.pem
''';
}
