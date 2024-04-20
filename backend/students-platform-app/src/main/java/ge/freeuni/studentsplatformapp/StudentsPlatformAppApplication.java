package ge.freeuni.studentsplatformapp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EnableJpaRepositories(basePackages = "ge.freeuni.studentsplatformapp.repository")
public class StudentsPlatformAppApplication {

	public static void main(String[] args) {
		SpringApplication.run(StudentsPlatformAppApplication.class, args);
	}

}
