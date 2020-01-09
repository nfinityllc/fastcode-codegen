spring.datasource.url=jdbc:h2:mem:[=Schema];INIT=CREATE SCHEMA IF NOT EXISTS [=Schema?upper_case]
spring.datasource.username=sa
spring.datasource.password=sa
spring.datasource.driverClassName=org.h2.Driver

spring.h2.console.enabled=true
spring.h2.console.path=/h2
jdbc.basic.maxOpenPreparedStatements=-1

spring.jpa.show-sql=true
spring.jpa.generate-ddl=true
spring.jpa.hibernate.ddl-auto=update
spring.jpa.properties.hibernate.format_sql=true