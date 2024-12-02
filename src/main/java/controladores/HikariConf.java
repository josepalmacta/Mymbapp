/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controladores;

/**
 *
 * @author Usuario
 */
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class HikariConf implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        
        HikariConfig hikariConfig = new HikariConfig();
        hikariConfig.setDriverClassName("org.postgresql.Driver");
        hikariConfig.setJdbcUrl("jdbc:postgresql://localhost:5432/proyectoTT");
        hikariConfig.setUsername("postgres");
        hikariConfig.setPassword("1");
        hikariConfig.setMaximumPoolSize(10);
        hikariConfig.setIdleTimeout(30000);
        hikariConfig.setConnectionTimeout(2000);
        hikariConfig.setMaxLifetime(1800000);
        hikariConfig.setLeakDetectionThreshold(300000);

        HikariDataSource dataSource = new HikariDataSource(hikariConfig);

        sce.getServletContext().setAttribute("dataSource", dataSource);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        HikariDataSource dataSource = (HikariDataSource) sce.getServletContext().getAttribute("dataSource");
        if (dataSource != null) {
            dataSource.close();
        }
    }
}

