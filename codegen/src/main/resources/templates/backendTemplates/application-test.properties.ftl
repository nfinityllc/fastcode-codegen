spring.datasource.url=jdbc:h2:mem:[=Schema];INIT=CREATE SCHEMA IF NOT EXISTS [=Schema?upper_case]
spring.datasource.username=sa
spring.datasource.password=sa
spring.datasource.driverClassName=org.h2.Driver

spring.h2.console.enabled=true
spring.h2.console.path=/h2
jdbc.basic.maxOpenPreparedStatements=-1
spring.jpa.properties.hibernate.jdbc.lob.non_contextual_creation=true
spring.jpa.properties.hibernate.default_schema=blog
spring.jpa.properties.hibernate.enable_lazy_load_no_trans=true

spring.jpa.show-sql=true
spring.jpa.generate-ddl=true
spring.jpa.hibernate.ddl-auto=update
spring.jpa.properties.hibernate.format_sql=true