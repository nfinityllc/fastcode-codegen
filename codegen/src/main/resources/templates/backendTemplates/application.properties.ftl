spring.datasource.url=[=connectionStringInfo.url]
spring.datasource.username=[=connectionStringInfo.username]
spring.datasource.password=[=connectionStringInfo.password]
spring.datasource.driverClassName=org.postgresql.Driver
spring.jpa.properties.hibernate.jdbc.lob.non_contextual_creation=true
spring.jpa.show-sql=true
spring.jpa.generate-ddl=true
spring.jpa.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.hibernate.ddl-auto=update

spring.application.name=[=appName]
server.port=5555
spring.main.banner-mode=off
javers.mapping-style=BEAN

fastCode.offset.default=0
fastCode.limit.default=10
fastCode.sort.direction.default=ASC
fastCode.sort.property.default=id