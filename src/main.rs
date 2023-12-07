use email_newsletter::startup::run;

#[tokio::main]
async fn main() -> Result<(), std::io::Error> {
    let listener = std::net::TcpListener::bind("127.0.0.1:8080")?;
    run(listener)?.await?;
    Ok(())
}
// Page 84
