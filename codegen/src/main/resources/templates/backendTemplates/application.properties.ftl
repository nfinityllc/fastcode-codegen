spring.profiles.active=local

spring.datasource.url=[=connectionStringInfo.url]
spring.datasource.username=[=connectionStringInfo.username]
spring.datasource.password=[=connectionStringInfo.password]
spring.datasource.driverClassName=org.postgresql.Driver
spring.jpa.properties.hibernate.jdbc.lob.non_contextual_creation=true
spring.jpa.properties.hibernate.default_schema=[=schema]
spring.jpa.show-sql=true
spring.jpa.generate-ddl=true
spring.jpa.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.properties.hibernate.enable_lazy_load_no_trans=true

spring.application.name=[=appName]
server.port=5555
spring.main.banner-mode=off
javers.mapping-style=BEAN
spring.jackson.serialization.fail-on-empty-beans=false

#applciation context path
server.servlet.contextPath=/

# SLF4J is a facade for logging frameworks
# Spring Boot overrides the default logging level of Logback by setting the root logger to info
logging.level.root=WARN
logging.level.org.springframework.web=DEBUG
logging.level.org.hibernate=ERROR
logging.level.org.hibernate.type.descriptor.sql=TRACE

logging.file=src/main/java/[=packageName]/logging/spring-boot-logging.txt
logging.file.max-history=2
logging.file.max-size=2000KB
<#if EmailModule!false>
spring.mail.default-encoding=UTF-8
spring.mail.host=smtp.gmail.com
spring.mail.username=info@righthire.com
spring.mail.password=KavitaKavya001
spring.mail.port=587
spring.mail.protocol=smtp
spring.mail.test-connection=false
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
spring.mail.properties.mail.smtp.connectiontimeout=5000
spring.mail.properties.mail.smtp.timeout=5000
spring.mail.properties.mail.smtp.writetimeout=5000

fastcode.emailconverter.xapikey=t7HdQfZjGp6R96fOV4P8v18ggf6LLTQZ1puUI2tz
fastcode.emailconverter.url=http://localhost:3001/
</#if>
# Enable SSL

# The format used for the keystore for openid testing
server.ssl.key-store-type=PKCS12
# The path to the keystore containing the certificate
server.ssl.key-store=classpath:keystore.p12
# The password used to generate the certificate
server.ssl.key-store-password=Rfhh8ek2
# The alias mapped to the certificate
server.ssl.key-alias=tomcat

fastCode.offset.default=0
fastCode.limit.default=10
fastCode.sort.direction.default=ASC
#fastCode.sort.property.default=id