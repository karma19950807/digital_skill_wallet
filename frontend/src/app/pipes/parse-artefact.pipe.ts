import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'parseArtefact',
  standalone: true
})
export class ParseArtefactPipe implements PipeTransform {
  transform(value: string): { link: string; project: string } {
    try {
      const parsed = JSON.parse(value);
      return {
        link: parsed.link || '#',
        project: parsed.project || 'Unknown Project'
      };
    } catch {
      return { link: '#', project: 'Invalid Artefact' };
    }
  }
}
