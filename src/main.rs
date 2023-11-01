use email_newsletter::run;

#[tokio::main]
pub async fn main() -> Result<(), std::io::Error> {
    run().await
}
// page: 50
