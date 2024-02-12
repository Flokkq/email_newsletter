# Important notes past 7.2.5

```rust
#[serde(rename_all = "PascalCase")]
struct Test {
    from: String,
    html_body: String,
}
```

# 7.5 Zero Downtime Deployment