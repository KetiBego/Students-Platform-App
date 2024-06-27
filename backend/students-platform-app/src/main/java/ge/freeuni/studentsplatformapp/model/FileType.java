package ge.freeuni.studentsplatformapp.model;

import lombok.Getter;

@Getter
public enum FileType {
    PDF("pdf"),
    PNG("png");

    private final String extension;

    FileType(String extension) {
        this.extension = extension;
    }

    public static FileType fromExtension(String extension) {
        for (FileType fileType : FileType.values()) {
            if (fileType.getExtension().equalsIgnoreCase(extension)) {
                return fileType;
            }
        }
        throw new IllegalArgumentException("Invalid file extension: " + extension);
    }
}
