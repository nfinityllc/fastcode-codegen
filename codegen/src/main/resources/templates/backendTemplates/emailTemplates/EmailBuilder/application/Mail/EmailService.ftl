package [=PackageName].application.mail;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.core.io.FileSystemResource;
import java.io.File;

@Service
public class EmailService implements IEmailService{

	@Autowired
	public JavaMailSender emailSender;

	@Transactional(propagation = Propagation.REQUIRED)
	@Override
	public void sendSimpleMessage(String to, String subject, String text)  {
		try {

            MimeMessage message = emailSender.createMimeMessage();

            //Set Email
           // message.setFrom("testemail@abc.com");
            
            MimeMessageHelper helper = new MimeMessageHelper(message, true);


			helper.setTo(to);
			helper.setSubject(subject);
			helper.setText(text,true);



			emailSender.send(message);
		}
		catch (MessagingException ex) {
			ex.printStackTrace();
		}
		

	}

	@Transactional(propagation = Propagation.REQUIRED)
	@Override
	public void sendSimpleMessageUsingTemplate(String to, String subject, SimpleMailMessage template,
			String... templateArgs) {
		// TODO Auto-generated method stub

	}

	@Transactional(propagation = Propagation.REQUIRED)
	@Override
	public void sendMessageWithAttachment(String to, String subject, String text, String pathToAttachment) {
		try {

			MimeMessage message = emailSender.createMimeMessage();

			//Set Email
			// message.setFrom("testemail@abc.com");

			MimeMessageHelper helper = new MimeMessageHelper(message, true);


			helper.setTo(to);
			helper.setSubject(subject);
			helper.setText(text,true);
			if(pathToAttachment != null) {
				FileSystemResource file = new FileSystemResource(new File(pathToAttachment));
				helper.addAttachment(pathToAttachment, file);
			}


			emailSender.send(message);
		}
		catch (MessagingException ex) {
			ex.printStackTrace();
		}

	}

}
