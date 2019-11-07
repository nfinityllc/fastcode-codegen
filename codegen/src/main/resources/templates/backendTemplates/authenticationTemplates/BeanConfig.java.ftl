package [=PackageName];

<#if Cache !false>
import java.util.ArrayList;
import java.util.List;

import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.cache.concurrent.ConcurrentMapCache;
import org.springframework.cache.support.SimpleCacheManager;
import org.springframework.cache.transaction.TransactionAwareCacheManagerProxy;
</#if>
<#if AuthenticationType != "none">
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
</#if>
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableSwagger2
<#if AuthenticationType != "none">
@EnableTransactionManagement
@EnableJpaRepositories
@EnableJpaAuditing(auditorAwareRef = "auditorProvider")
</#if>
public class BeanConfig {

<#if AuthenticationType != "none">
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
</#if>

<#if Cache !false>
  @Bean
    public CacheManager cacheManager() {
        SimpleCacheManager cacheManager = new SimpleCacheManager();

        List<Cache> caches = new ArrayList<>();
        <#if (AuthenticationType!="none" && !UserInput??) >
        caches.add(new ConcurrentMapCache("[=AuthenticationTable]"));
        </#if>
        <#if AuthenticationType != "none">
        caches.add(new ConcurrentMapCache("Role"));
        caches.add(new ConcurrentMapCache("Permission"));
        caches.add(new ConcurrentMapCache("Rolepermission"));
        caches.add(new ConcurrentMapCache("[=AuthenticationTable]permission"));
        </#if>
        <#list EntitiesMap as entityKey, entityMap>
		caches.add(new ConcurrentMapCache("[=entityKey?cap_first]"));
		</#list>

        cacheManager.setCaches(caches );

        // manually call initialize the caches as our SimpleCacheManager is not declared as a bean
        cacheManager.initializeCaches();

        return new TransactionAwareCacheManagerProxy( cacheManager );
    }
</#if>    

    @Bean
    public Docket api() {
        return new Docket(DocumentationType.SWAGGER_2)
                .select()
                .apis(RequestHandlerSelectors.any())
                .paths(PathSelectors.any())
                .build()
                .pathMapping("/");
    }
    
}
