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

fastCode.offset.default=0
fastCode.limit.default=10
fastCode.sort.direction.default=ASC
#fastCode.sort.property.default=id