import { Controller } from "@hotwired/stimulus";
import { thumbHashToDataURL } from "thumbhash";

export default class extends Controller {
  static values = { previewHash: String };
  previewHashValue!: string;

  connect(): void {
    const byteArray = this.hexToBytes(this.previewHashValue);
    (
      this.element as HTMLElement
    ).style.backgroundImage = `url(${thumbHashToDataURL(byteArray)})`;
  }

  hexToBytes(hex: string): Array<number> {
    const bytes: number[] = [];
    for (let i = 0; i < hex.length; i += 2) {
      bytes.push(parseInt(hex.substring(i, i + 2), 16));
    }
    return bytes;
  }
}
