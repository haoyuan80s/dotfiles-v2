import json

rust = {
    "region": {
        "prefix": "#region",
        "body": """// region:   --- ${1:name}

// endregion: --- ${1:name}
""",
    },
    "dummy error": {
        "prefix": "#dummy_error",
        "body": """// region:   --- error
pub type Result<T> = std::result::Result<T, Error>;
pub type Error = Box<dyn std::error::Error + Send + Sync + 'static>;
// endregion: --- error
""",
    },
    "error region": {
        "prefix": "#error_region",
        "body": """// region:   --- error
use derive_more::{Error, From};

pub type Result<T> = std::result::Result<T, Error>;

#[derive(Debug, From, Error)]
pub enum Error {
    #[from]
    Anyhow(anyhow::Error),
}

impl std::fmt::Display for Error {
    fn fmt(&self, fmt: &mut std::fmt::Formatter) -> std::result::Result<(), std::fmt::Error> {
        write!(fmt, "{self:?}")
    }
}
// endregion: --- error
""",
    },
    "error from": {
        "prefix": "#error_from",
        "body": """
impl From<${1:module}::Error> for Error {
    fn from(err: ${1:module}::Error) -> Self {
        Self::${2:Variant}(err)
    }
}
// endregion: --- error
""",
    },
    "test async": {
        "prefix": "#test_async",
        "body": """#[tokio::test]
async fn ${1:test_name}() {
    ${2:todo!()}
}
        """,
    },
    "test": {
        "prefix": "#test",
        "body": """#[test]
fn ${1:test_name}() {
    ${2:todo!()}
}
        """,
    },
    "test region": {
        "prefix": "#test_region",
        "body": """#[cfg(test)]
mod tests {
    #[allow(unused)]
    use super::*;

    #[test]
    fn ${1:test_name}() {
        ${2:todo!()}
    }
}
        """,
    },
}

with open("rust.json", "w") as f:
    json.dump(rust, f, indent=2)
