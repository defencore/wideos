#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// ojd block size
#define INBLK_SIZE 0x200

// A config audio qbox that we can prepend to a qbox stream from an ojd
const char config_audio_qbox[] = {
    // BEGIN QBOX HEADER
    0x00, 0x00, 0x00, 0x1A, // box_size, 26 bytes
    'q',  'b',  'o',  'x',  // box_type, magic number
    0x00, 0x00, 0x00, 0x01, // box_flags, data-present flag set
    0x00, 0x01, 0x00, 0x01, // sample_stream_type . sample_stream_id, set to 0x1 for AAC audio
    0x00, 0x00, 0x00, 0x01, // sample_flags, has SAMPLE_FLAGS_CONFIGURATION_INFO and nothing else
    0x00, 0x00, 0x00, 0x00, // sample_cts, not used here (TODO: is this the right move here?)
    // END QBOX HEADER
    // BEGIN AAC AudioSpecificConfig
    0x14, 0x10,             // 5 bits: 0x2==0b00010 (AAC_LC), 4 bits: 0x8==0b1000 (default sample rate = 16000 Hz), 4 bits: 0x2==0b0010 (2-channel stereo),
                            // GASpecificConfig: 1 bit frameLengthFlag==0 (use 1024/128), 1 bit dependsOnCoreCoder==0, 1 bit extensionFlag==0
                            // 00010 1000 0010 0 0 0 == 0b0001010000010000 == 0x1410
};

int main(int argc, char *argv[])
{
    char block[INBLK_SIZE];
    char *infile_name = NULL;
    char *outfile_name = NULL;
    FILE *infile;
    FILE *outfile;

    if (config_audio_qbox[3] != sizeof(config_audio_qbox))
    { 
        printf("Failed config audio qbox size assert!\n");
        exit(1);
    }

    if (argc > 1)
    {
        char *fileargptr = argv[argc-1];
        size_t str_size = strlen(fileargptr) + 1;

        if (str_size < 5 || fileargptr[str_size-5] != '.' || fileargptr[str_size-4] != 'o' || fileargptr[str_size-3] != 'j' || fileargptr[str_size-2] != 'd')
        {
            printf("Arg must be a .ojd file!\n");
            exit(1);
        }

        infile_name = malloc(str_size);
        outfile_name = malloc(str_size);

        if (!infile_name || !outfile_name)
        {
            free(infile_name);
            free(outfile_name);
            printf("Error allocating mem!\n");
            exit(1);
        }

        memcpy(infile_name, fileargptr, str_size);
        memcpy(outfile_name, fileargptr, str_size);

        // output file will have a .qbx extension, as in the Mobilygen examples
        outfile_name[str_size-4] = 'q';
        outfile_name[str_size-3] = 'b';
        outfile_name[str_size-2] = 'x';
    }
    else
    {
        printf("Not enough arguments!!\n");
        exit(1);
    }

    infile = fopen(infile_name, "rb");
    outfile = fopen(outfile_name, "wb");

    if (argc >= 2 && strcmp(argv[argc-2], "aqboxp") == 0)
    {
        printf("Prepending audio config qbox...\n");
        fwrite(config_audio_qbox, sizeof(config_audio_qbox), 1, outfile);
    }

    printf("Converting ojd blocks to qbox stream...\n");
    while (fread(block, INBLK_SIZE, 1, infile))
    {
        int bufval = 0;
        int i;

        for (i = 0; i < 8; i++)
        {
            bufval |= block[i];
        }

        if (bufval == 0)
        {
            // Reached ojd padding at end of file, apparently
            break;
        }

        fwrite(block + 0x8, INBLK_SIZE - 0x8, 1, outfile);
    }

    printf("Done! Saved qbox stream to %s\n", outfile_name);

    free(infile_name);
    free(outfile_name);
    fclose(infile);
    fclose(outfile);

    return 0;
}
