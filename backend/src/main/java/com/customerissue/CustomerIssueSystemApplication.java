package com.customerissue;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * 客户问题系统主应用程序
 * 
 * @author Customer Issue System
 * @version 1.0.0
 */
@SpringBootApplication
@EnableAsync
@EnableCaching
@EnableScheduling
@MapperScan("com.customerissue.mapper")
public class CustomerIssueSystemApplication {

    public static void main(String[] args) {
        SpringApplication.run(CustomerIssueSystemApplication.class, args);
        System.out.println("""
            
            ████████████████████████████████████████████████████████████████
            █                                                              █
            █          🎯 Customer Issue System Started Successfully!     █
            █                                                              █
            █          🌐 Frontend: http://localhost:3000                  █
            █          🔗 Backend API: http://localhost:8080               █
            █          📚 API Docs: http://localhost:8080/swagger-ui.html  █
            █          ⚡ Health Check: http://localhost:8080/actuator/health █
            █                                                              █
            ████████████████████████████████████████████████████████████████
            """);
    }
} 